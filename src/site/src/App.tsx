import './App.css'

const audiences = [
  {
    name: '科研团队',
    description: '面向国内外高校科研团队的数据处理服务，交付周期灵活，质量优先',
  },
  {
    name: '科技企业',
    description: '面向高新科技企业的数据服务与咨询，按时交付，流程规范',
  },
]

const strengths = [
  {
    name: '数据工程能力',
    description: '十年积累的数据工程能力及标准化体系',
  },
  {
    name: '产教融合',
    description: '与量潮课堂共享同一内核：项目经验变成课程内容，培训学员变成项目人力',
  },
]

export default function App() {
  return (
    <main className="app">
      <section className="hero">
        <h1>量潮数据</h1>
        <p className="tagline">数据处理服务与咨询</p>
        <p className="intro">
          服务国内外高校科研团队与高新科技企业，卡在需求大而市场供给稀缺的位置上。
        </p>
      </section>
      <section className="clouds">
        <h2>服务对象</h2>
        <div className="cloud-grid">
          {audiences.map((item) => (
            <div key={item.name} className="cloud-card">
              <h3>{item.name}</h3>
              <p className="description">{item.description}</p>
            </div>
          ))}
        </div>
      </section>
      <section className="clouds">
        <h2>核心竞争力</h2>
        <div className="cloud-grid">
          {strengths.map((item) => (
            <div key={item.name} className="cloud-card">
              <h3>{item.name}</h3>
              <p className="description">{item.description}</p>
            </div>
          ))}
        </div>
      </section>
    </main>
  )
}
