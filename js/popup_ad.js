window.addEventListener("load", function() {
    const key = "_adblockNotified";
    
    if (this.localStorage.getItem(key) !== '1' 
        && window.confirm("You are NOT using an adblocker. Please install one for your own sake.")) {
        window.open("https://ublockorigin.com/");
    }

    this.localStorage.setItem(key, '1');
})
