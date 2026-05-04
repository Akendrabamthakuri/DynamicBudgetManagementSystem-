<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.budgetmanagement.model.User" %>
<%@ page import="com.budgetmanagement.model.Transaction" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - BudgetTrack</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%
    User user = (User) session.getAttribute("user");
    List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
    double totalIncome = (double) request.getAttribute("totalIncome");
    double totalExpense = (double) request.getAttribute("totalExpense");
    double balance = (double) request.getAttribute("balance");
    String period = (String) request.getAttribute("period");
    if (period == null) period = "month";

    // Build category breakdown for pie chart
    Map<String, Double> categoryMap = new LinkedHashMap<>();
    if (transactions != null) {
        for (Transaction t : transactions) {
            if ("Expense".equals(t.getType())) {
                categoryMap.merge(t.getCategory(), t.getAmount(), Double::sum);
            }
        }
    }
    StringBuilder pieLabels = new StringBuilder();
    StringBuilder pieData = new StringBuilder();
    for (Map.Entry<String, Double> entry : categoryMap.entrySet()) {
        if (pieLabels.length() > 0) { pieLabels.append(","); pieData.append(","); }
        pieLabels.append("'").append(entry.getKey()).append("'");
        pieData.append(entry.getValue());
    }
%>
<nav class="navbar">
    <span class="brand">BudgetTrack</span>
    <div class="nav-links">
        <a href="dashboard">Dashboard</a>
        <a href="profile">Profile</a>
        <a href="logout">Logout</a>
    </div>
</nav>

<div class="page-wrapper">
    <div class="dashboard-header">
        <h2>Welcome, <%= user.getUsername() %>!</h2>
        <div class="period-btns">
            <a href="dashboard?period=month" class="period-btn <%= "month".equals(period) ? "active" : "" %>">This Month</a>
            <a href="dashboard?period=week" class="period-btn <%= "week".equals(period) ? "active" : "" %>">Last 7 Days</a>
            <a href="dashboard?period=all" class="period-btn <%= "all".equals(period) ? "active" : "" %>">All Time</a>
        </div>
    </div>

    <!-- Budget Warning -->
    <% if (user.getBudgetLimit() > 0 && totalExpense > user.getBudgetLimit()) {
           double exceeded = totalExpense - user.getBudgetLimit(); %>
        <div class="budget-warning">
            ⚠️ Warning: You have exceeded your monthly budget by Rs. <%= String.format("%.2f", exceeded) %>!
        </div>
    <% } %>

    <!-- Summary Cards -->
    <div class="summary-cards">
        <div class="card income">
            <p>Total Income</p>
            <h3>Rs. <%= String.format("%.2f", totalIncome) %></h3>
        </div>
        <div class="card expense">
            <p>Total Expense</p>
            <h3>Rs. <%= String.format("%.2f", totalExpense) %></h3>
        </div>
        <div class="card balance">
            <p>Balance</p>
            <h3>Rs. <%= String.format("%.2f", balance) %></h3>
        </div>
        <div class="card budget">
            <p>Budget Limit <span class="badge-active">Active</span></p>
            <h3>Rs. <%= String.format("%.2f", user.getBudgetLimit()) %></h3>
            <%
                double usedPercent = user.getBudgetLimit() > 0 ? (totalExpense / user.getBudgetLimit()) * 100 : 0;
                if (usedPercent > 100) usedPercent = 100;
            %>
            <div class="progress-bar-bg">
                <div class="progress-bar-fill" style="width: <%= String.format("%.0f", usedPercent) %>%"></div>
            </div>
            <p class="progress-label"><%= String.format("%.0f", usedPercent) %>% Used</p>
        </div>
    </div>

    <!-- Charts Section -->
    <div class="charts-row">
        <div class="chart-card">
            <h4>Income vs Expense Overview</h4>
            <canvas id="barChart"></canvas>
        </div>
        <div class="chart-card">
            <h4>Expense Breakdown</h4>
            <canvas id="pieChart"></canvas>
        </div>
    </div>

    <!-- Search and Filter -->
    <div class="search-filter-row">
        <input type="text" id="searchInput" class="search-bar" placeholder="Search by description or category..." onkeyup="filterTable()">
        <div class="filter-btns">
            <button class="filter-btn active" onclick="setFilter('all', this)">All</button>
            <button class="filter-btn" onclick="setFilter('income', this)">Income</button>
            <button class="filter-btn" onclick="setFilter('expense', this)">Expense</button>
        </div>
    </div>

    <!-- Transactions Table -->
    <div class="section-header">
        <h3>Transactions</h3>
        <a href="transactions" class="btn-primary">+ Add Transaction</a>
    </div>

    <table class="data-table" id="transactionTable">
        <thead>
            <tr>
                <th>Date</th>
                <th>Type</th>
                <th>Category</th>
                <th>Description</th>
                <th>Amount</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody id="tableBody">
        <% if (transactions != null && !transactions.isEmpty()) {
               for (Transaction t : transactions) { %>
            <tr data-type="<%= t.getType().toLowerCase() %>">
                <td><%= t.getTransactionDate() %></td>
                <td><span class="badge <%= t.getType().toLowerCase() %>"><%= t.getType() %></span></td>
                <td><%= t.getCategory() %></td>
                <td><%= t.getDescription() != null ? t.getDescription() : "-" %></td>
                <td>Rs. <%= String.format("%.2f", t.getAmount()) %></td>
                <td>
                    <a href="transactions?action=edit&id=<%= t.getId() %>" class="btn-edit">Edit</a>
                    <a href="transactions?action=delete&id=<%= t.getId() %>" class="btn-delete" onclick="return confirm('Delete this transaction?')">Delete</a>
                </td>
            </tr>
        <% } } else { %>
            <tr><td colspan="6" class="empty-msg">No transactions found. Add one!</td></tr>
        <% } %>
        </tbody>
    </table>

    <p class="last-updated">Last Updated: Today</p>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Bar Chart
    new Chart(document.getElementById('barChart'), {
        type: 'bar',
        data: {
            labels: ['Income', 'Expense'],
            datasets: [{
                label: 'Amount (Rs.)',
                data: [<%= totalIncome %>, <%= totalExpense %>],
                backgroundColor: ['#2ecc71', '#e74c3c'],
                borderRadius: 8,
                barThickness: 50
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true } }
        }
    });

    // Pie Chart
    new Chart(document.getElementById('pieChart'), {
        type: 'doughnut',
        data: {
            labels: [<%= pieLabels %>],
            datasets: [{
                data: [<%= pieData %>],
                backgroundColor: ['#e74c3c','#3498db','#f39c12','#9b59b6','#1abc9c','#e67e22','#2ecc71','#e91e63'],
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { position: 'bottom' } }
        }
    });

    // Search filter
    var currentFilter = 'all';
    function filterTable() {
        var input = document.getElementById('searchInput').value.toLowerCase();
        var rows = document.getElementById('tableBody').getElementsByTagName('tr');
        for (var i = 0; i < rows.length; i++) {
            var type = rows[i].getAttribute('data-type') || '';
            var text = rows[i].innerText.toLowerCase();
            var matchSearch = text.indexOf(input) > -1;
            var matchFilter = currentFilter === 'all' || type === currentFilter;
            rows[i].style.display = matchSearch && matchFilter ? '' : 'none';
        }
    }
    function setFilter(filter, btn) {
        currentFilter = filter;
        var btns = document.getElementsByClassName('filter-btn');
        for (var i = 0; i < btns.length; i++) btns[i].classList.remove('active');
        btn.classList.add('active');
        filterTable();
    }
</script>
</body>
</html>
