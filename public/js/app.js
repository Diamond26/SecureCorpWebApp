// app.js - Main Application Logic

console.log('app.js loaded');

// Check authentication
if (!auth.isAuthenticated()) {
    console.log('User not authenticated, redirecting to login');
    window.location.href = '/login.html';
}

console.log('User authenticated:', auth.getUser());

// Update navbar with user info
document.getElementById('navUsername').textContent = auth.getUser().username;
document.getElementById('navRole').textContent = auth.isAdmin() ? 'Amministratore' : 'Utente';

// Logout handler
document.getElementById('logoutBtn').addEventListener('click', () => {
    auth.logout();
});

// ==================== TEMPLATES ====================

const templates = {
    // DASHBOARD TEMPLATE
    dashboard: () => `
        <div class="container">
            <div class="header">
                <h1>I Miei Ticket</h1>
                <a href="#" data-route="new-ticket" class="btn btn-success">+ Nuovo Ticket</a>
            </div>
            <div id="ticketsContainer" class="loading">Caricamento ticket...</div>
        </div>
    `,

    // ADMIN DASHBOARD TEMPLATE
    admin: () => `
        <div class="container">
            <div class="header">
                <h1>Dashboard Amministratore</h1>
                <div class="header-actions">
                    <a href="#" data-route="users" class="btn btn-info">Gestione Utenti</a>
                    <button class="btn btn-success" id="newUserBtn">+ Nuovo Utente</button>
                </div>
            </div>

            <div id="errorMessage" class="error-message"></div>
            <div id="successMessage" class="success-message"></div>

            <div class="stats">
                <div class="stat-card">
                    <div class="stat-value" id="totalTickets">0</div>
                    <div class="stat-label">Ticket Totali</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" id="openTickets">0</div>
                    <div class="stat-label">Aperti</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" id="inProgressTickets">0</div>
                    <div class="stat-label">In Lavorazione</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" id="closedTickets">0</div>
                    <div class="stat-label">Chiusi</div>
                </div>
            </div>

            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Titolo</th>
                            <th class="type-header">Tipo</th>
                            <th>Creatore</th>
                            <th>Status</th>
                            <th>Data</th>
                            <th class="actions-header">Azioni</th>
                        </tr>
                    </thead>
                    <tbody id="ticketsTable">
                        <tr><td colspan="7" class="loading">Caricamento ticket...</td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Modal Nuovo Utente -->
        <div id="newUserModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Registra Nuovo Utente</h2>
                    <button class="close-modal" onclick="closeNewUserModal()">×</button>
                </div>
                <div id="modalError" class="error-message"></div>
                <div id="modalSuccess" class="success-message"></div>
                <form id="newUserForm">
                    <div class="form-group">
                        <div class="input-wrapper">
                            <label for="newUsername">Username *</label>
                            <input type="text" id="newUsername" required minlength="3" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-wrapper">
                            <label for="newPassword">Password *</label>
                            <input type="password" id="newPassword" required minlength="6">
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-wrapper">
                            <label for="userType">Tipo Utente *</label>
                            <select id="userType" required>
                                <option value="USER">Utente</option>
                                <option value="ADMIN">Amministratore</option>
                            </select>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width: 100%;">Crea Utente</button>
                </form>
            </div>
        </div>

        <!-- Modal Modifica Status -->
        <div id="statusModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Modifica Status Ticket</h2>
                    <button class="close-modal" onclick="closeStatusModal()">×</button>
                </div>
                <div id="statusModalError" class="error-message"></div>
                <form id="statusForm">
                    <div class="form-group">
                        <div class="input-wrapper">
                            <label for="ticketStatus">Nuovo Status *</label>
                            <select id="ticketStatus" required>
                                <option value="OPEN">Aperto</option>
                                <option value="IN_PROGRESS">In Lavorazione</option>
                                <option value="CLOSED">Chiuso</option>
                            </select>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width: 100%;">Aggiorna Status</button>
                </form>
            </div>
        </div>
    `,

    // NEW TICKET TEMPLATE
    newTicket: () => `
        <div class="container">
            <div class="card">
                <h1>Nuovo Ticket</h1>
                <div id="errorMessage" class="error-message"></div>
                <div id="successMessage" class="success-message"></div>
                <form id="ticketForm">
                    <div class="form-group">
                        <div class="input-wrapper">
                            <label for="ticketType">Tipo di Ticket *</label>
                            <select id="ticketType" required>
                                <option value="">Seleziona un tipo...</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-wrapper">
                            <label for="title">Titolo *</label>
                            <input type="text" id="title" required maxlength="120" placeholder="Inserisci un titolo descrittivo">
                            <div class="char-counter"><span id="titleCounter">0</span> / 120</div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-wrapper">
                            <label for="description">Descrizione *</label>
                            <textarea id="description" required maxlength="2000" placeholder="Descrivi il problema o la richiesta in dettaglio..."></textarea>
                            <div class="char-counter"><span id="descCounter">0</span> / 2000</div>
                        </div>
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary" id="submitBtn">✓ Crea Ticket</button>
                        <a href="#" data-route="${auth.isAdmin() ? 'admin' : 'dashboard'}" class="btn btn-secondary">✕ Annulla</a>
                    </div>
                </form>
            </div>
        </div>
    `,

    // TICKET DETAIL TEMPLATE
    ticketDetail: (params) => `
        <div class="container">
            <div id="errorMessage" class="error-message"></div>
            <div id="successMessage" class="success-message"></div>
            <div id="ticketContent" class="loading">Caricamento ticket...</div>
        </div>
    `,

    // USERS MANAGEMENT TEMPLATE
    users: () => `
        <div class="container">
            <div class="header">
                <h1>Gestione Utenti</h1>
                <button class="btn btn-success" id="newUserBtn">+ Nuovo Utente</button>
            </div>

            <div id="errorMessage" class="error-message"></div>
            <div id="successMessage" class="success-message"></div>

            <div class="stats">
                <div class="stat-card">
                    <div class="stat-value" id="totalUsers">0</div>
                    <div class="stat-label">Utenti Totali</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" id="adminCount">0</div>
                    <div class="stat-label">Amministratori</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" id="userCount">0</div>
                    <div class="stat-label">Utenti Standard</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" id="activeCount">0</div>
                    <div class="stat-label">Utenti Attivi</div>
                </div>
            </div>

            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th class="type-header">Tipo</th>
                            <th>Status</th>
                            <th>Creato</th>
                            <th class="actions-header">Azioni</th>
                        </tr>
                    </thead>
                    <tbody id="usersTable">
                        <tr><td colspan="6" class="loading">Caricamento utenti...</td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Modal Nuovo Utente -->
        <div id="newUserModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Nuovo Utente</h2>
                    <button class="close-modal" onclick="closeNewUserModal()">×</button>
                </div>
                <div id="modalError" class="error-message"></div>
                <form id="newUserForm">
                    <div class="form-group">
                        <div class="input-wrapper">
                            <label for="newUsername">Username *</label>
                            <input type="text" id="newUsername" required minlength="3" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-wrapper">
                            <label for="newPassword">Password *</label>
                            <input type="password" id="newPassword" required minlength="6">
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-wrapper">
                            <label for="userType">Tipo *</label>
                            <select id="userType" required>
                                <option value="USER">Utente</option>
                                <option value="ADMIN">Admin</option>
                            </select>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width:100%;">Crea Utente</button>
                </form>
            </div>
        </div>

        <!-- Modal Modifica Utente -->
        <div id="editModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Modifica Utente</h2>
                    <button class="close-modal" onclick="closeEditModal()">×</button>
                </div>
                <div id="editError" class="error-message"></div>
                <form id="editForm">
                    <div class="form-group">
                        <div class="input-wrapper">
                            <label for="editUsername">Username</label>
                            <input type="text" id="editUsername" minlength="3" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-wrapper">
                            <label for="editType">Tipo</label>
                            <select id="editType">
                                <option value="USER">Utente</option>
                                <option value="ADMIN">Admin</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-wrapper">
                            <label for="editActive">Status</label>
                            <select id="editActive">
                                <option value="1">Attivo</option>
                                <option value="0">Inattivo</option>
                            </select>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width:100%;">Salva Modifiche</button>
                </form>
            </div>
        </div>

        <!-- Modal Cambio Password -->
        <div id="passwordModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Cambia Password</h2>
                    <button class="close-modal" onclick="closePasswordModal()">×</button>
                </div>
                <div id="passwordError" class="error-message"></div>
                <form id="passwordForm">
                    <div class="form-group">
                        <div class="input-wrapper">
                            <label for="newPasswordInput">Nuova Password *</label>
                            <input type="password" id="newPasswordInput" required minlength="6">
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width:100%;">Cambia Password</button>
                </form>
            </div>
        </div>
    `
};

// ==================== UTILITY FUNCTIONS ====================

const showError = (m) => {
    const el = document.getElementById('errorMessage');
    if (el) {
        el.textContent = m;
        el.style.display = 'block';
        const success = document.getElementById('successMessage');
        if (success) success.style.display = 'none';
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
};

const showSuccess = (m) => {
    const el = document.getElementById('successMessage');
    if (el) {
        el.textContent = m;
        el.style.display = 'block';
        const error = document.getElementById('errorMessage');
        if (error) error.style.display = 'none';
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
};

const hideMessages = () => {
    const error = document.getElementById('errorMessage');
    const success = document.getElementById('successMessage');
    if (error) error.style.display = 'none';
    if (success) success.style.display = 'none';
};

const formatDate = (d) => new Date(d).toLocaleDateString('it-IT', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
});

const animateCount = (el, value) => {
    const duration = 800;
    const startTime = performance.now();
    const step = (now) => {
        const progress = Math.min((now - startTime) / duration, 1);
        const current = Math.round(value * progress);
        el.textContent = current;
        if (progress < 1) requestAnimationFrame(step);
    };
    requestAnimationFrame(step);
};

// ==================== API FUNCTIONS ====================

async function apiRequest(url, options = {}) {
    const defaultOptions = {
        headers: {
            'Authorization': `Bearer ${auth.getToken()}`,
            'Content-Type': 'application/json',
            ...options.headers
        }
    };

    const response = await fetch(url, { ...options, ...defaultOptions });

    if (response.status === 401 || response.status === 403) {
        const refreshed = await auth.refresh();
        if (refreshed) {
            defaultOptions.headers.Authorization = `Bearer ${auth.getToken()}`;
            return await fetch(url, { ...options, ...defaultOptions });
        } else {
            window.location.href = '/login.html';
            throw new Error('Authentication failed');
        }
    }

    return response;
}

// ==================== DASHBOARD FUNCTIONS ====================

async function loadDashboardTickets() {
    try {
        const response = await apiRequest('/api/tickets');
        const tickets = await response.json();
        const container = document.getElementById('ticketsContainer');

        if (tickets.length === 0) {
            container.innerHTML = `
                <div class="empty-state">
                    <div class="empty-state-icon">📋</div>
                    <h2>Nessun ticket trovato</h2>
                    <p>Crea il tuo primo ticket per iniziare</p>
                    <a href="#" data-route="new-ticket" class="btn btn-primary">+ Crea Ticket</a>
                </div>
            `;
        } else {
            container.innerHTML = '';
            container.className = 'tickets-grid';
            tickets.forEach(ticket => {
                container.appendChild(createTicketCard(ticket));
            });
        }
    } catch (error) {
        console.error(error);
        document.getElementById('ticketsContainer').textContent = '⚠️ Errore nel caricamento dei ticket';
    }
}

function createTicketCard(ticket) {
    const card = document.createElement('div');
    card.className = 'ticket-card';
    card.onclick = () => router.navigate('ticket-detail', { id: ticket.id });

    const header = document.createElement('div');
    header.className = 'ticket-header';

    const title = document.createElement('div');
    title.className = 'ticket-title';
    title.textContent = ticket.title;

    const status = document.createElement('span');
    status.className = `ticket-status status-${ticket.status}`;
    status.textContent = ticket.status_desc;

    header.appendChild(title);
    header.appendChild(status);

    const description = document.createElement('div');
    description.className = 'ticket-description';
    description.textContent = ticket.description;

    const meta = document.createElement('div');
    meta.className = 'ticket-meta';

    const type = document.createElement('span');
    type.className = 'ticket-type';
    type.textContent = ticket.ticket_type_desc;

    const date = document.createElement('span');
    date.className = 'ticket-date';
    date.textContent = formatDate(ticket.created_at);

    meta.appendChild(type);
    meta.appendChild(date);

    card.appendChild(header);
    card.appendChild(description);
    card.appendChild(meta);

    return card;
}

// ==================== ADMIN DASHBOARD FUNCTIONS ====================

let adminCurrentTicketId = null;
let adminStatsAnimated = false;

async function loadAdminTickets() {
    try {
        const response = await apiRequest('/api/tickets');
        const tickets = await response.json();

        const totalTickets = tickets.length;
        const openTickets = tickets.filter(x => x.status === 'OPEN').length;
        const inProgressTickets = tickets.filter(x => x.status === 'IN_PROGRESS').length;
        const closedTickets = tickets.filter(x => x.status === 'CLOSED').length;

        if (!adminStatsAnimated) {
            animateCount(document.getElementById('totalTickets'), totalTickets);
            animateCount(document.getElementById('openTickets'), openTickets);
            animateCount(document.getElementById('inProgressTickets'), inProgressTickets);
            animateCount(document.getElementById('closedTickets'), closedTickets);
            adminStatsAnimated = true;
        } else {
            document.getElementById('totalTickets').textContent = totalTickets;
            document.getElementById('openTickets').textContent = openTickets;
            document.getElementById('inProgressTickets').textContent = inProgressTickets;
            document.getElementById('closedTickets').textContent = closedTickets;
        }

        renderAdminTicketsTable(tickets);
    } catch (error) {
        console.error(error);
        showError('Errore nel caricamento dei ticket');
    }
}

function renderAdminTicketsTable(tickets) {
    const tbody = document.getElementById('ticketsTable');
    tbody.innerHTML = '';

    if (tickets.length === 0) {
        const tr = document.createElement('tr');
        const td = document.createElement('td');
        td.colSpan = 7;
        td.className = 'empty-state';
        td.innerHTML = '<h2>Nessun ticket presente</h2><p>I ticket creati appariranno qui</p>';
        tr.appendChild(td);
        tbody.appendChild(tr);
        return;
    }

    tickets.forEach(ticket => {
        const tr = document.createElement('tr');

        const tdId = document.createElement('td');
        tdId.textContent = '#' + ticket.id;
        tdId.style.fontWeight = '600';
        tdId.style.color = '#d4af37';

        const tdTitle = document.createElement('td');
        tdTitle.textContent = ticket.title;
        tdTitle.style.maxWidth = '300px';
        tdTitle.style.fontWeight = '600';

        const tdType = document.createElement('td');
        tdType.className = 'type-cell';
        const typeSpan = document.createElement('span');
        typeSpan.className = 'ticket-type';
        typeSpan.textContent = ticket.ticket_type_desc;
        tdType.appendChild(typeSpan);

        const tdCreator = document.createElement('td');
        tdCreator.textContent = ticket.creator;

        const tdStatus = document.createElement('td');
        const statusSpan = document.createElement('span');
        statusSpan.className = `ticket-status status-${ticket.status}`;
        statusSpan.textContent = ticket.status_desc;
        tdStatus.appendChild(statusSpan);

        const tdDate = document.createElement('td');
        tdDate.textContent = formatDate(ticket.created_at);
        tdDate.style.whiteSpace = 'nowrap';

        const tdActions = document.createElement('td');
        tdActions.className = 'actions-cell';
        const actionsGroup = document.createElement('div');
        actionsGroup.className = 'actions-group';

        const viewBtn = document.createElement('button');
        viewBtn.className = 'btn btn-primary btn-sm';
        viewBtn.textContent = 'Vedi';
        viewBtn.onclick = () => router.navigate('ticket-detail', { id: ticket.id });

        const statusBtn = document.createElement('button');
        statusBtn.className = 'btn btn-warning btn-sm';
        statusBtn.textContent = 'Status';
        statusBtn.onclick = () => {
            adminCurrentTicketId = ticket.id;
            document.getElementById('ticketStatus').value = ticket.status;
            document.getElementById('statusModal').classList.add('active');
            document.getElementById('statusModalError').style.display = 'none';
        };

        actionsGroup.appendChild(viewBtn);
        actionsGroup.appendChild(statusBtn);
        tdActions.appendChild(actionsGroup);

        tr.appendChild(tdId);
        tr.appendChild(tdTitle);
        tr.appendChild(tdType);
        tr.appendChild(tdCreator);
        tr.appendChild(tdStatus);
        tr.appendChild(tdDate);
        tr.appendChild(tdActions);

        tbody.appendChild(tr);
    });
}

// Admin modal handlers
window.closeNewUserModal = function() {
    document.getElementById('newUserModal').classList.remove('active');
    const form = document.getElementById('newUserForm');
    if (form) form.reset();
    const error = document.getElementById('modalError');
    if (error) error.style.display = 'none';
    const success = document.getElementById('modalSuccess');
    if (success) success.style.display = 'none';
};

window.closeStatusModal = function() {
    document.getElementById('statusModal').classList.remove('active');
    const form = document.getElementById('statusForm');
    if (form) form.reset();
    const error = document.getElementById('statusModalError');
    if (error) error.style.display = 'none';
    adminCurrentTicketId = null;
};

async function setupAdminHandlers() {
    document.getElementById('newUserBtn').addEventListener('click', () => {
        document.getElementById('newUserModal').classList.add('active');
        document.getElementById('newUserForm').reset();
        document.getElementById('modalError').style.display = 'none';
        const success = document.getElementById('modalSuccess');
        if (success) success.style.display = 'none';
    });

    document.getElementById('newUserForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        document.getElementById('modalError').style.display = 'none';

        const username = document.getElementById('newUsername').value.trim();
        const password = document.getElementById('newPassword').value;
        const user_type = document.getElementById('userType').value;

        try {
            const response = await apiRequest('/api/auth/register', {
                method: 'POST',
                body: JSON.stringify({ username, password, user_type })
            });

            const data = await response.json();

            if (response.ok) {
                const modalSuccess = document.getElementById('modalSuccess');
                if (modalSuccess) {
                    modalSuccess.textContent = 'Utente creato con successo!';
                    modalSuccess.style.display = 'block';
                }
                document.getElementById('newUserForm').reset();
                setTimeout(() => closeNewUserModal(), 2000);
            } else {
                const modalError = document.getElementById('modalError');
                if (modalError) {
                    modalError.textContent = 'Errore: ' + (data.error || 'Errore durante la creazione');
                    modalError.style.display = 'block';
                }
            }
        } catch (error) {
            console.error(error);
            const modalError = document.getElementById('modalError');
            if (modalError) {
                modalError.textContent = 'Errore di connessione al server';
                modalError.style.display = 'block';
            }
        }
    });

    document.getElementById('statusForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        document.getElementById('statusModalError').style.display = 'none';

        const status = document.getElementById('ticketStatus').value;

        try {
            const response = await apiRequest(`/api/tickets/${adminCurrentTicketId}/status`, {
                method: 'PATCH',
                body: JSON.stringify({ status })
            });

            const data = await response.json();

            if (response.ok) {
                showSuccess('Status aggiornato con successo!');
                closeStatusModal();
                loadAdminTickets();
            } else {
                const error = document.getElementById('statusModalError');
                if (error) {
                    error.textContent = 'Errore: ' + (data.error || "Errore durante l'aggiornamento");
                    error.style.display = 'block';
                }
            }
        } catch (error) {
            console.error(error);
            const errorEl = document.getElementById('statusModalError');
            if (errorEl) {
                errorEl.textContent = 'Errore di connessione al server';
                errorEl.style.display = 'block';
            }
        }
    });
}

// ==================== NEW TICKET FUNCTIONS ====================

async function loadTicketTypes() {
    try {
        const response = await apiRequest('/api/tickets/meta/types');
        if (response.ok) {
            const types = await response.json();
            const select = document.getElementById('ticketType');
            types.forEach(type => {
                const option = document.createElement('option');
                option.value = type.code;
                option.textContent = type.description;
                select.appendChild(option);
            });
        }
    } catch (error) {
        console.error(error);
    }
}

function setupNewTicketHandlers() {
    const titleInput = document.getElementById('title');
    const descInput = document.getElementById('description');
    const titleCounter = document.getElementById('titleCounter');
    const descCounter = document.getElementById('descCounter');

    titleInput.addEventListener('input', () => {
        const length = titleInput.value.length;
        titleCounter.textContent = length;
        const counter = titleCounter.parentElement;
        counter.classList.remove('warning', 'error');
        if (length > 100) counter.classList.add('warning');
        if (length > 115) counter.classList.add('error');
    });

    descInput.addEventListener('input', () => {
        const length = descInput.value.length;
        descCounter.textContent = length;
        const counter = descCounter.parentElement;
        counter.classList.remove('warning', 'error');
        if (length > 1800) counter.classList.add('warning');
        if (length > 1950) counter.classList.add('error');
    });

    document.getElementById('ticketForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        hideMessages();

        const submitBtn = document.getElementById('submitBtn');
        const ticketType = document.getElementById('ticketType').value;
        const title = titleInput.value.trim();
        const description = descInput.value.trim();

        if (!ticketType || !title || !description) {
            showError('⚠️ Tutti i campi sono obbligatori');
            return;
        }

        if (title.length > 120) {
            showError('⚠️ Il titolo è troppo lungo');
            return;
        }

        if (description.length > 2000) {
            showError('⚠️ La descrizione è troppo lunga');
            return;
        }

        submitBtn.classList.add('loading');
        submitBtn.disabled = true;

        try {
            const response = await apiRequest('/api/tickets', {
                method: 'POST',
                body: JSON.stringify({ ticket_type: ticketType, title, description })
            });

            const data = await response.json();

            if (response.ok) {
                showSuccess('✓ Ticket creato con successo!');
                document.getElementById('ticketForm').reset();
                titleCounter.textContent = '0';
                descCounter.textContent = '0';
                submitBtn.textContent = '✓ Creato!';
                submitBtn.classList.remove('loading');
                setTimeout(() => {
                    router.navigate(auth.isAdmin() ? 'admin' : 'dashboard');
                }, 1500);
            } else {
                submitBtn.classList.remove('loading');
                submitBtn.disabled = false;
                showError('✗ ' + (data.error || 'Errore durante la creazione'));
            }
        } catch (error) {
            console.error(error);
            submitBtn.classList.remove('loading');
            submitBtn.disabled = false;
            showError('✗ Errore di connessione al server');
        }
    });
}

// ==================== TICKET DETAIL FUNCTIONS ====================

async function loadTicketDetail(params) {
    const ticketId = params.id;
    if (!ticketId) {
        router.navigate(auth.isAdmin() ? 'admin' : 'dashboard');
        return;
    }

    try {
        const response = await apiRequest(`/api/tickets/${ticketId}`);

        if (response.status === 404) {
            showError('Ticket non trovato');
            return;
        }

        if (!response.ok) {
            const data = await response.json();
            showError(data.error || 'Errore');
            return;
        }

        const ticket = await response.json();
        renderTicketDetail(ticket);
    } catch (error) {
        console.error(error);
        showError('Errore di connessione');
    }
}

function renderTicketDetail(ticket) {
    const container = document.getElementById('ticketContent');
    container.innerHTML = '';
    container.classList.remove('loading');

    const card = document.createElement('div');
    card.className = 'card';

    const header = document.createElement('div');
    header.className = 'ticket-header';

    const titleSection = document.createElement('div');
    titleSection.className = 'ticket-title';

    const titleRow = document.createElement('div');
    titleRow.className = 'title-row';

    const h1 = document.createElement('h1');
    h1.textContent = ticket.title;

    const statusSpan = document.createElement('span');
    statusSpan.className = `ticket-status status-${ticket.status} status-inline`;
    statusSpan.textContent = ` ${ticket.status_desc}`;

    titleRow.appendChild(h1);
    titleRow.appendChild(statusSpan);
    titleSection.appendChild(titleRow);

    const infoGrid = document.createElement('div');
    infoGrid.className = 'info-grid';

    const creatorItem = document.createElement('div');
    creatorItem.className = 'info-item';
    creatorItem.innerHTML = `
        <div class="info-label">Creatore</div>
        <div class="info-value">${ticket.creator || 'Non disponibile'}</div>
    `;

    const typeItem = document.createElement('div');
    typeItem.className = 'info-item';
    typeItem.innerHTML = `
        <div class="info-label">Tipo ticket</div>
        <div class="info-value">${ticket.ticket_type_desc}</div>
    `;

    const dateItem = document.createElement('div');
    dateItem.className = 'info-item';
    dateItem.innerHTML = `
        <div class="info-label">Creato il</div>
        <div class="info-value">${formatDate(ticket.created_at)}</div>
    `;

    infoGrid.appendChild(creatorItem);
    infoGrid.appendChild(typeItem);
    infoGrid.appendChild(dateItem);
    titleSection.appendChild(infoGrid);

    header.appendChild(titleSection);

    const descSection = document.createElement('div');
    descSection.innerHTML = `
        <div class="section-title">Descrizione</div>
        <div class="ticket-description">${ticket.description}</div>
    `;

    card.appendChild(header);
    card.appendChild(descSection);

    // Show edit button only for ticket owner and if status is OPEN
    if (ticket.user_id === auth.getUser().id && ticket.status === 'OPEN') {
        const actionButtons = document.createElement('div');
        actionButtons.className = 'action-buttons';

        const editBtn = document.createElement('button');
        editBtn.className = 'btn btn-primary';
        editBtn.textContent = 'Modifica Ticket';
        editBtn.onclick = () => document.getElementById('editForm').style.display = 'block';

        actionButtons.appendChild(editBtn);
        card.appendChild(actionButtons);
    }

    container.appendChild(card);

    // Add edit form
    const editCard = document.createElement('div');
    editCard.className = 'card edit-form';
    editCard.id = 'editForm';
    editCard.innerHTML = `
        <div class="section-title">Modifica Ticket</div>
        <form id="updateForm">
            <div class="form-group">
                <label>Titolo *</label>
                <input type="text" id="editTitle" value="${ticket.title}" maxlength="120" required>
            </div>
            <div class="form-group">
                <label>Descrizione *</label>
                <textarea id="editDescription" maxlength="2000" required>${ticket.description}</textarea>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Salva</button>
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('editForm').style.display='none'">Annulla</button>
            </div>
        </form>
    `;

    container.appendChild(editCard);

    // Setup edit form handler
    const updateForm = document.getElementById('updateForm');
    if (updateForm) {
        updateForm.onsubmit = async (e) => {
            e.preventDefault();

            const title = document.getElementById('editTitle').value.trim();
            const description = document.getElementById('editDescription').value.trim();

            if (!title || !description) {
                showError('Campi obbligatori mancanti');
                return;
            }

            try {
                const response = await apiRequest(`/api/tickets/${ticket.id}`, {
                    method: 'PATCH',
                    body: JSON.stringify({ title, description })
                });

                const data = await response.json();

                if (response.ok) {
                    showSuccess('Ticket aggiornato con successo!');
                    document.getElementById('editForm').style.display = 'none';
                    setTimeout(() => loadTicketDetail({ id: ticket.id }), 1000);
                } else {
                    showError('Errore: ' + (data.error || "Errore durante l'aggiornamento"));
                }
            } catch (error) {
                console.error(error);
                showError('Errore di connessione al server');
            }
        };
    }
}

// ==================== USERS MANAGEMENT FUNCTIONS ====================

let currentUserId = null;
let usersStatsAnimated = false;

async function loadUsers() {
    try {
        const response = await apiRequest('/api/auth/users');
        if (response.status === 401 || response.status === 403) {
            window.location.href = '/login.html';
            return;
        }

        const users = await response.json();

        const totalUsers = users.length;
        const adminCount = users.filter(x => x.user_type === 'ADMIN').length;
        const userCount = users.filter(x => x.user_type === 'USER').length;
        const activeCount = users.filter(x => x.is_active).length;

        if (!usersStatsAnimated) {
            animateCount(document.getElementById('totalUsers'), totalUsers);
            animateCount(document.getElementById('adminCount'), adminCount);
            animateCount(document.getElementById('userCount'), userCount);
            animateCount(document.getElementById('activeCount'), activeCount);
            usersStatsAnimated = true;
        } else {
            document.getElementById('totalUsers').textContent = totalUsers;
            document.getElementById('adminCount').textContent = adminCount;
            document.getElementById('userCount').textContent = userCount;
            document.getElementById('activeCount').textContent = activeCount;
        }

        renderUsersTable(users);
    } catch (error) {
        console.error(error);
        showError('Errore nel caricamento degli utenti');
    }
}

function renderUsersTable(users) {
    const tbody = document.getElementById('usersTable');
    tbody.innerHTML = '';

    users.forEach(u => {
        const tr = document.createElement('tr');

        const tdId = document.createElement('td');
        tdId.textContent = '#' + u.id;
        tdId.style.fontWeight = '600';
        tdId.style.color = '#d4af37';

        const tdUser = document.createElement('td');
        tdUser.textContent = u.username;
        tdUser.style.fontWeight = '600';

        const tdType = document.createElement('td');
        tdType.className = 'type-cell';
        const typeBadge = document.createElement('span');
        typeBadge.className = `user-badge badge-${u.user_type.toLowerCase()}`;
        typeBadge.textContent = u.user_type_desc;
        tdType.appendChild(typeBadge);

        const tdStatus = document.createElement('td');
        const statusBadge = document.createElement('span');
        statusBadge.className = `status-badge status-${u.is_active ? 'active' : 'inactive'}`;
        statusBadge.textContent = u.is_active ? 'Attivo' : 'Inattivo';
        tdStatus.appendChild(statusBadge);

        const tdDate = document.createElement('td');
        tdDate.textContent = formatDate(u.created_at);
        tdDate.style.whiteSpace = 'nowrap';

        const tdActions = document.createElement('td');
        tdActions.className = 'actions-cell';
        const actionsGroup = document.createElement('div');
        actionsGroup.className = 'actions-group';

        const editBtn = document.createElement('button');
        editBtn.className = 'btn btn-primary btn-sm';
        editBtn.textContent = 'Modifica';
        editBtn.onclick = () => {
            currentUserId = u.id;
            document.getElementById('editUsername').value = u.username;
            document.getElementById('editType').value = u.user_type;
            document.getElementById('editActive').value = u.is_active ? '1' : '0';
            document.getElementById('editModal').classList.add('active');
            document.getElementById('editError').style.display = 'none';
        };

        const pwBtn = document.createElement('button');
        pwBtn.className = 'btn btn-warning btn-sm';
        pwBtn.textContent = 'Password';
        pwBtn.onclick = () => {
            currentUserId = u.id;
            document.getElementById('newPasswordInput').value = '';
            document.getElementById('passwordModal').classList.add('active');
            document.getElementById('passwordError').style.display = 'none';
        };

        const delBtn = document.createElement('button');
        delBtn.className = 'btn btn-danger btn-sm';
        delBtn.textContent = 'Elimina';
        delBtn.onclick = async () => {
            if (!confirm(`Eliminare l'utente "${u.username}"? Questa azione è irreversibile!`)) return;

            try {
                const response = await apiRequest(`/api/auth/users/${u.id}`, { method: 'DELETE' });
                const data = await response.json();

                if (response.ok) {
                    showSuccess('Utente eliminato con successo!');
                    loadUsers();
                } else {
                    showError('Errore: ' + (data.error || "Errore durante l'eliminazione"));
                }
            } catch (error) {
                console.error(error);
                showError('Errore di connessione al server');
            }
        };

        if (u.id === auth.getUser().id) delBtn.disabled = true;

        actionsGroup.appendChild(editBtn);
        actionsGroup.appendChild(pwBtn);
        actionsGroup.appendChild(delBtn);
        tdActions.appendChild(actionsGroup);

        tr.appendChild(tdId);
        tr.appendChild(tdUser);
        tr.appendChild(tdType);
        tr.appendChild(tdStatus);
        tr.appendChild(tdDate);
        tr.appendChild(tdActions);

        tbody.appendChild(tr);
    });
}

// Users modal handlers
window.closeEditModal = function() {
    document.getElementById('editModal').classList.remove('active');
    document.getElementById('editForm').reset();
    document.getElementById('editError').style.display = 'none';
    currentUserId = null;
};

window.closePasswordModal = function() {
    document.getElementById('passwordModal').classList.remove('active');
    document.getElementById('passwordForm').reset();
    document.getElementById('passwordError').style.display = 'none';
    currentUserId = null;
};

function setupUsersHandlers() {
    document.getElementById('newUserBtn').addEventListener('click', () => {
        document.getElementById('newUserModal').classList.add('active');
        document.getElementById('newUserForm').reset();
        document.getElementById('modalError').style.display = 'none';
    });

    document.getElementById('newUserForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        document.getElementById('modalError').style.display = 'none';

        const username = document.getElementById('newUsername').value.trim();
        const password = document.getElementById('newPassword').value;
        const user_type = document.getElementById('userType').value;

        try {
            const response = await apiRequest('/api/auth/register', {
                method: 'POST',
                body: JSON.stringify({ username, password, user_type })
            });

            const data = await response.json();

            if (response.ok) {
                showSuccess('Utente creato con successo!');
                closeNewUserModal();
                loadUsers();
            } else {
                const modalError = document.getElementById('modalError');
                if (modalError) {
                    modalError.textContent = 'Errore: ' + (data.error || 'Errore durante la creazione');
                    modalError.style.display = 'block';
                }
            }
        } catch (error) {
            console.error(error);
            const modalError = document.getElementById('modalError');
            if (modalError) {
                modalError.textContent = 'Errore di connessione al server';
                modalError.style.display = 'block';
            }
        }
    });

    document.getElementById('editForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        document.getElementById('editError').style.display = 'none';

        const username = document.getElementById('editUsername').value.trim();
        const user_type = document.getElementById('editType').value;
        const is_active = document.getElementById('editActive').value === '1';

        try {
            const response = await apiRequest(`/api/auth/users/${currentUserId}`, {
                method: 'PATCH',
                body: JSON.stringify({ username, user_type, is_active })
            });

            const data = await response.json();

            if (response.ok) {
                showSuccess('Utente aggiornato con successo!');
                closeEditModal();
                loadUsers();
            } else {
                const editError = document.getElementById('editError');
                if (editError) {
                    editError.textContent = 'Errore: ' + (data.error || "Errore durante l'aggiornamento");
                    editError.style.display = 'block';
                }
            }
        } catch (error) {
            console.error(error);
            const editError = document.getElementById('editError');
            if (editError) {
                editError.textContent = 'Errore di connessione al server';
                editError.style.display = 'block';
            }
        }
    });

    document.getElementById('passwordForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        document.getElementById('passwordError').style.display = 'none';

        const new_password = document.getElementById('newPasswordInput').value;

        try {
            const response = await apiRequest(`/api/auth/users/${currentUserId}/password`, {
                method: 'PATCH',
                body: JSON.stringify({ new_password })
            });

            const data = await response.json();

            if (response.ok) {
                showSuccess('Password cambiata con successo!');
                closePasswordModal();
            } else {
                const passwordError = document.getElementById('passwordError');
                if (passwordError) {
                    passwordError.textContent = 'Errore: ' + (data.error || 'Errore durante il cambio password');
                    passwordError.style.display = 'block';
                }
            }
        } catch (error) {
            console.error(error);
            const passwordError = document.getElementById('passwordError');
            if (passwordError) {
                passwordError.textContent = 'Errore di connessione al server';
                passwordError.style.display = 'block';
            }
        }
    });
}

// ==================== ROUTE REGISTRATION ====================

// Wait for DOM to be ready
document.addEventListener('DOMContentLoaded', () => {
    console.log('DOM Ready - Initializing app...');
    
    // Initialize router
    const contentContainer = document.getElementById('app-content');
    if (!contentContainer) {
        console.error('app-content container not found!');
        return;
    }
    
    router.init(contentContainer);
    console.log('Router initialized');

    // Register routes
    router.register('dashboard', {
        path: '/dashboard',
        showNavbar: true,
        template: templates.dashboard,
        onLoad: loadDashboardTickets
    });

    router.register('admin', {
        path: '/admin',
        showNavbar: true,
        requiresAdmin: true,
        template: templates.admin,
        onLoad: async () => {
            await loadAdminTickets();
            setupAdminHandlers();
        }
    });

    router.register('new-ticket', {
        path: '/new-ticket',
        showNavbar: true,
        template: templates.newTicket,
        onLoad: async () => {
            await loadTicketTypes();
            setupNewTicketHandlers();
        }
    });

    router.register('ticket-detail', {
        path: '/ticket-detail',
        showNavbar: true,
        template: templates.ticketDetail,
        onLoad: loadTicketDetail
    });

    router.register('users', {
        path: '/users',
        showNavbar: true,
        requiresAdmin: true,
        template: templates.users,
        onLoad: async () => {
            await loadUsers();
            setupUsersHandlers();
        }
    });

    console.log('Routes registered');

    // ==================== INITIALIZATION ====================

    // Load initial route based on user type
    console.log('User type:', auth.getUser().user_type);
    if (auth.isAdmin()) {
        console.log('Loading admin dashboard...');
        router.navigate('admin');
    } else {
        console.log('Loading user dashboard...');
        router.navigate('dashboard');
    }
});