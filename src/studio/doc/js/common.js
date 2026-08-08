// ================================================================
//  公共交互：toast 与资料弹窗
// ================================================================
let toastTimer = null;

function showToast(msg) {
    const toast = document.getElementById('toast');
    if (!toast) return;
    toast.textContent = msg;
    toast.classList.add('show');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => toast.classList.remove('show'), 2500);
}

function closeDocModal() {
    const modal = document.getElementById('docModal');
    if (modal) modal.classList.remove('active');
}

const docModal = document.getElementById('docModal');
if (docModal) {
    docModal.addEventListener('click', function(e) {
        if (e.target === this) closeDocModal();
    });
}
