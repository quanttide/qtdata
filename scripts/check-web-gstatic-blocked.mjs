#!/usr/bin/env node
// 屏蔽 gstatic 的线上验收：模拟「国外 CDN 打不开」的机器打开 studio，
// 检查：入口标题、布局渲染、文字可见（截图）、CanvasKit 走本地、无控制台错误。
//
// 用法：node check-web-gstatic-blocked.mjs [url] [等待毫秒] [截图路径]
// 依赖：本机 Chrome + Node ≥ 22（原生 WebSocket）；需先起 CDP：
//   google-chrome --headless=new --disable-gpu --no-sandbox \
//     --enable-unsafe-swiftshader --remote-debugging-port=9222 \
//     --user-data-dir=/tmp/qtdata-cdp about:blank
// 退出码：0 验收通过；1 未通过。

const url = process.argv[2] || 'https://studio.data.quanttide.com/';
const waitMs = Number(process.argv[3] || 20000);
const shotPath = process.argv[4] || '/tmp/qtdata-gstatic-blocked.png';

const list = await (await fetch('http://localhost:9222/json/list')).json();
const page = list.find((t) => t.type === 'page');
if (!page) {
  console.error('✗ 找不到 CDP 页面目标，先按文件头注释起 Chrome');
  process.exit(1);
}
const ws = new WebSocket(page.webSocketDebuggerUrl);
let id = 0;
const pending = new Map();
const consoleErrors = [];
const external = [];
const send = (method, params = {}) =>
  new Promise((res, rej) => {
    const mid = ++id;
    pending.set(mid, { res, rej });
    ws.send(JSON.stringify({ id: mid, method, params }));
  });
ws.onmessage = (ev) => {
  const m = JSON.parse(ev.data);
  if (m.id && pending.has(m.id)) {
    const { res, rej } = pending.get(m.id);
    pending.delete(m.id);
    m.error ? rej(new Error(JSON.stringify(m.error))) : res(m.result);
  } else if (m.method === 'Network.requestWillBeSent') {
    const u = m.params.request.url;
    if (/gstatic|googleapis/.test(u)) external.push(u);
  } else if (m.method === 'Runtime.exceptionThrown') {
    consoleErrors.push(JSON.stringify(m.params.exceptionDetails).slice(0, 300));
  } else if (m.method === 'Runtime.consoleAPICalled' && m.params.type === 'error') {
    consoleErrors.push(m.params.args.map((a) => a.value ?? a.description ?? '').join(' ').slice(0, 300));
  }
};
await new Promise((r) => { ws.onopen = r; });
await send('Page.enable');
await send('Runtime.enable');
await send('Network.enable');
await send('Network.setBlockedURLs', { urls: ['*gstatic.com*', '*googleapis.com*'] });
await send('Emulation.setDeviceMetricsOverride', { width: 1440, height: 900, deviceScaleFactor: 1, mobile: false });
await send('Page.navigate', { url });
await new Promise((r) => setTimeout(r, waitMs));

const { result } = await send('Runtime.evaluate', {
  expression: `(() => {
    const res = performance.getEntriesByType('resource').map(e => ({
      n: e.name.replace(/^https?:\\/\\/[^/]+\\//, ''), s: e.responseStatus || 0
    }));
    return JSON.stringify({
      title: document.title,
      bad: res.filter(r => r.s >= 400),
      canvaskitFrom: [...new Set(res.filter(r => r.n.includes('canvaskit')).map(r => r.n.split('/')[0]))],
      seed: res.filter(r => r.n.includes('seed')).map(r => r.s),
      fonts: res.filter(r => r.n.includes('NotoSansSC')).length
    });
  })()`,
  returnByValue: true,
});
const state = JSON.parse(result.value);
// 浏览器默认探测 /favicon.ico（index.html 实际引的是 favicon.png），不算应用资源
const bad = state.bad.filter((r) => r.n !== 'favicon.ico');
const shot = await send('Page.captureScreenshot', { format: 'png' });
const fs = await import('node:fs');
fs.writeFileSync(shotPath, Buffer.from(shot.data, 'base64'));
const shotSize = fs.statSync(shotPath).size;

const uniqExternal = [...new Set(external)];
const checks = [
  ['标题为量潮数据', state.title === '量潮数据', state.title],
  ['无 4xx/5xx 资源', bad.length === 0, JSON.stringify(bad)],
  ['CanvasKit 走本地', state.canvaskitFrom.length === 1 && state.canvaskitFrom[0] === 'canvaskit', state.canvaskitFrom.join(',')],
  ['seed 已加载', state.seed.length > 0 && state.seed.every((s) => s === 200), JSON.stringify(state.seed)],
  ['自带字体已加载', state.fonts >= 4, String(state.fonts)],
  ['截图非空白（文字已渲染）', shotSize > 20000, `${shotSize} bytes`],
  ['无控制台错误', consoleErrors.length === 0, consoleErrors.join(' | ')],
];
let pass = true;
for (const [name, ok, detail] of checks) {
  console.log(`${ok ? '✓' : '✗'} ${name}: ${detail}`);
  if (!ok) pass = false;
}
console.log(`gstatic 外部请求 ${external.length} 次（应仅剩字体试探或为 0）: ${uniqExternal.slice(0, 3).join(', ') || '无'}`);
console.log(`截图: ${shotPath}`);
ws.close();
process.exit(pass ? 0 : 1);
