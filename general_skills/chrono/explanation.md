# chrono

## Description
How to automate tasks to run at intervals on linux servers?
Additional details will be available after launching your challenge instance.

## Solution
To connect use:
```
ssh picoplayer@saturn.picoctf.net -p 57734
```

Tasks in linux can be sheduled using `cron`. This suggests, that the flag is hidden in that programs config files which are stored in /etc

```
picoplayer@challenge:~$ ll /etc | grep cron
drwxr-xr-x 1 root   root       26 Mar 16 02:00 cron.d/
drwxr-xr-x 1 root   root       26 Mar 16 02:00 cron.daily/
drwxr-xr-x 2 root   root       26 Mar 16 02:00 cron.hourly/
drwxr-xr-x 2 root   root       26 Mar 16 02:00 cron.monthly/
drwxr-xr-x 2 root   root       26 Mar 16 02:00 cron.weekly/
-rw-r--r-- 1 root   root       43 Mar 16 02:01 crontab
picoplayer@challenge:~$ cat /etc/crontab
# picoCTF{Sch3DUL7NG_T45K3_L1NUX_0bb95b71}
```
