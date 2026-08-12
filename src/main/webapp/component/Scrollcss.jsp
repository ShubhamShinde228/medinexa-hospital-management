<style>
.scroll-container {
    width: 100%;
    overflow: hidden;
    background: #333;
    color: white;
    font-size: 24px;
    font-weight: bold;
    white-space: nowrap;
    position: relative;
    padding: 10px 0;
}

.scroll-text {
    display: inline-block;
    animation: scroll 10s linear infinite;
}

@keyframes scroll {
    from {
        transform: translateX(-100%);
    }
    to {
        transform: translateX(100%);
    }
}

</style>
