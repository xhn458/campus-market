<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Campus Market student marketplace beta">
    <title>Campus Market</title>
    <link rel="stylesheet" href="/assets/css/app.css">
    <script src="/assets/js/app.js" defer></script>
</head>
<body>
<div class="beta-banner">Beta test application — do not enter real payment or banking information.</div>
<header class="site-header">
    <a class="brand" href="/">Campus Market</a>
    <nav aria-label="Main navigation">
        <a href="#marketplace">Marketplace</a>
        <a href="#about">About</a>
    </nav>
</header>

<main>
    <section class="hero">
        <p class="eyebrow">Built for college communities</p>
        <h1>Buy and sell with students on your campus.</h1>
        <p class="hero-copy">Campus Market is getting ready for its first beta. This starter verifies that the PHP application and MySQL setup work.</p>
        <div class="actions">
            <button id="check-status" type="button">Check system status</button>
            <span id="system-status" class="status <?= $databaseConnected ? 'ready' : 'pending' ?>" role="status">
                <?= $databaseConnected ? 'Database connected' : 'Database setup required' ?>
            </span>
        </div>
    </section>

    <section id="marketplace" class="section" aria-labelledby="marketplace-title">
        <div>
            <p class="eyebrow">Sprint 1 foundation</p>
            <h2 id="marketplace-title">Marketplace preview</h2>
        </div>
        <div class="listing-grid">
            <article class="listing-card">
                <div class="listing-image" aria-hidden="true">Textbooks</div>
                <div class="listing-body"><h3>Calculus textbook</h3><p>$25 · UTC</p></div>
            </article>
            <article class="listing-card">
                <div class="listing-image accent" aria-hidden="true">Dorm</div>
                <div class="listing-body"><h3>Desk lamp</h3><p>$12 · UTC</p></div>
            </article>
            <article class="listing-card">
                <div class="listing-image warm" aria-hidden="true">Tech</div>
                <div class="listing-body"><h3>Wireless keyboard</h3><p>$30 · UTC</p></div>
            </article>
        </div>
    </section>

    <section id="about" class="section about">
        <p class="eyebrow">Project status</p>
        <h2>Foundation ready for team development</h2>
        <p>Registration, login, listing creation, and real marketplace data will be implemented through their Jira tickets.</p>
    </section>
</main>

<footer>Campus Market · CPSC 4910 Senior Capstone · Fall 2026</footer>
</body>
</html>
