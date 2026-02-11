

let currentPage = 1;
const logsPerPage = 50;
let currentFilters = {
    action: '',
    entity_type: '',
    date_from: '',
    date_to: ''
};

const API_URL = '/api';

const getToken = () => sessionStorage.getItem('accessToken');

const checkAuth = () => {
    const token = getToken();
    if (!token) {
        window.location.href = 'login.html';
        return false;
    }

    try {
        const payload = JSON.parse(atob(token.split('.')[1]));
        if (payload.user_type_code !== 'ADMIN') {
            alert('Accesso negato: solo amministratori possono visualizzare i log');
            window.location.href = 'index.html';
            return false;
        }
    } catch (e) {
        window.location.href = 'login.html';
        return false;
    }

    return true;
};

const formatDate = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleString('it-IT', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
    });
};

const getActionBadgeClass = (action) => {
    if (action.includes('SUCCESS') || action.includes('CREATED')) return 'badge-success';
    if (action.includes('FAILED') || action.includes('DELETED')) return 'badge-danger';
    if (action.includes('UPDATED') || action.includes('CHANGED')) return 'badge-warning';
    if (action.includes('LOGOUT')) return 'badge-secondary';
    return 'badge-info';
};

const formatMetadata = (metadata) => {
    if (!metadata) return '-';
    try {
        const obj = typeof metadata === 'string' ? JSON.parse(metadata) : metadata;
        const str = JSON.stringify(obj);
        return str.length > 50 ? str.substring(0, 50) + '...' : str;
    } catch (e) {
        return String(metadata).substring(0, 50);
    }
};

const loadFilterOptions = async () => {
    try {
        const token = getToken();

        const actionsRes = await fetch(`${API_URL}/admin/logs/actions`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        if (actionsRes.ok) {
            const actions = await actionsRes.json();
            const actionSelect = document.getElementById('filterAction');
            actions.forEach(action => {
                const option = document.createElement('option');
                option.value = action;
                option.textContent = action;
                actionSelect.appendChild(option);
            });
        }

        const typesRes = await fetch(`${API_URL}/admin/logs/entity-types`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        if (typesRes.ok) {
            const types = await typesRes.json();
            const typeSelect = document.getElementById('filterEntityType');
            types.forEach(type => {
                const option = document.createElement('option');
                option.value = type;
                option.textContent = type;
                typeSelect.appendChild(option);
            });
        }
    } catch (error) {
        console.error('Errore caricamento opzioni filtro:', error);
    }
};

const loadLogs = async (page = 1) => {
    try {
        const token = getToken();
        const logsLoading = document.getElementById('logsLoading');
        const logsTable = document.getElementById('logsTable');
        const logsError = document.getElementById('logsError');

        logsLoading.style.display = 'block';
        logsTable.style.display = 'none';
        logsError.style.display = 'none';

        const params = new URLSearchParams({
            page,
            limit: logsPerPage
        });

        if (currentFilters.action) params.append('action', currentFilters.action);
        if (currentFilters.entity_type) params.append('entity_type', currentFilters.entity_type);
        if (currentFilters.date_from) params.append('date_from', currentFilters.date_from);
        if (currentFilters.date_to) params.append('date_to', currentFilters.date_to);

        const response = await fetch(`${API_URL}/admin/logs?${params.toString()}`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });

        if (!response.ok) {
            throw new Error(await response.text());
        }

        const data = await response.json();

        renderLogs(data.logs);
        renderPagination(data.pagination);
        updateTotalLogs(data.pagination.total);

        currentPage = page;

        logsLoading.style.display = 'none';
        logsTable.style.display = 'table';

    } catch (error) {
        console.error('Errore caricamento log:', error);
        document.getElementById('logsLoading').style.display = 'none';
        const errorEl = document.getElementById('logsError');
        errorEl.textContent = 'Errore durante il caricamento dei log: ' + error.message;
        errorEl.style.display = 'block';
    }
};

const renderLogs = (logs) => {
    const tbody = document.getElementById('logsTableBody');
    tbody.innerHTML = '';

    if (logs.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" style="text-align:center;padding:40px;color:#999;">Nessun log trovato</td></tr>';
        return;
    }

    logs.forEach(log => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
      <td>${formatDate(log.created_at)}</td>
      <td><strong>${log.username || 'Sistema'}</strong></td>
      <td><span class="badge ${getActionBadgeClass(log.action)}">${log.action}</span></td>
      <td>${log.entity_type || '-'} ${log.entity_id ? `#${log.entity_id}` : ''}</td>
      <td>${log.description || '-'}</td>
      <td class="ip-address">${log.ip_address || '-'}</td>
      <td class="metadata" title="${log.metadata ? JSON.stringify(log.metadata) : ''}">${formatMetadata(log.metadata)}</td>
    `;
        tbody.appendChild(tr);
    });
};

const renderPagination = (pagination) => {
    const pageInfo = document.getElementById('pageInfo');
    const prevBtn = document.getElementById('prevPageBtn');
    const nextBtn = document.getElementById('nextPageBtn');

    pageInfo.textContent = `Pagina ${pagination.page} di ${pagination.totalPages}`;

    prevBtn.disabled = !pagination.hasPrevPage;
    nextBtn.disabled = !pagination.hasNextPage;
};

const updateTotalLogs = (total) => {
    document.getElementById('totalLogs').textContent = `Totale: ${total} log`;
};

document.addEventListener('DOMContentLoaded', () => {
    if (!checkAuth()) return;

    loadFilterOptions();
    loadLogs(1);

    document.getElementById('applyFiltersBtn').addEventListener('click', () => {
        currentFilters.action = document.getElementById('filterAction').value;
        currentFilters.entity_type = document.getElementById('filterEntityType').value;

        const dateFrom = document.getElementById('filterDateFrom').value;
        const dateTo = document.getElementById('filterDateTo').value;

        currentFilters.date_from = dateFrom ? new Date(dateFrom).toISOString() : '';
        currentFilters.date_to = dateTo ? new Date(dateTo).toISOString() : '';

        loadLogs(1);
    });

    document.getElementById('resetFiltersBtn').addEventListener('click', () => {
        document.getElementById('filterAction').value = '';
        document.getElementById('filterEntityType').value = '';
        document.getElementById('filterDateFrom').value = '';
        document.getElementById('filterDateTo').value = '';

        currentFilters = { action: '', entity_type: '', date_from: '', date_to: '' };
        loadLogs(1);
    });

    document.getElementById('refreshBtn').addEventListener('click', () => {
        loadLogs(currentPage);
    });

    document.getElementById('prevPageBtn').addEventListener('click', () => {
        if (currentPage > 1) {
            loadLogs(currentPage - 1);
        }
    });

    document.getElementById('nextPageBtn').addEventListener('click', () => {
        loadLogs(currentPage + 1);
    });

    document.getElementById('logoutBtn').addEventListener('click', async (e) => {
        e.preventDefault();
        const refreshToken = sessionStorage.getItem('refreshToken');

        if (refreshToken) {
            try {
                await fetch(`${API_URL}/auth/logout`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${getToken()}`
                    },
                    body: JSON.stringify({ refreshToken })
                });
            } catch (error) {
                console.error('Errore logout:', error);
            }
        }

        sessionStorage.clear();
        window.location.href = 'login.html';
    });
});
