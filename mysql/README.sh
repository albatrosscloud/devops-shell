CRON EXAMPLE
--

Execute Every Hour

* */1 * * * /lost+found/devops-shell/mysql/agraria-dropbox.sh > /dev/null 2>&1


Execute Every Day at 01 hour

00 01 * * * /lost+found/devops-shell/mysql/agraria-dropbox.sh > /dev/null 2>&1


