const statusButton = document.querySelector('#check-status');
const statusText = document.querySelector('#system-status');

statusButton?.addEventListener('click', async () => {
    statusButton.disabled = true;
    statusText.textContent = 'Checking…';

    try {
        const response = await fetch('/api/health');
        const result = await response.json();
        const ready = response.ok && result.database === 'connected';

        statusText.textContent = ready ? 'PHP and MySQL are connected' : 'PHP works; MySQL setup is required';
        statusText.className = `status ${ready ? 'ready' : 'pending'}`;
    } catch {
        statusText.textContent = 'Unable to reach the PHP backend';
        statusText.className = 'status pending';
    } finally {
        statusButton.disabled = false;
    }
});
