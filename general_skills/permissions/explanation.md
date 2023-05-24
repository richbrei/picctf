# Permissions

## Description

Can you read files in the root file?
Additional details will be available after launching your challenge instance.

## Solution

Starting the instance you are provided with an ssh login. Using it you get into a Ubuntu instance on AWS. As the challenge suggests that the flag is hidden somewhere in the "root file" we can check out what's in the / (root) directory running `ls -la /` and we see that there is another directory in there called `/root`. On this dir we do not have any persmissions as a user. We can run `sudo -l` to see what sudo permissions we have 

```
picoplayer@challenge:~$ sudo -l
[sudo] password for picoplayer:
Matching Defaults entries for picoplayer on challenge:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User picoplayer may run the following commands on challenge:
    (ALL) /usr/bin/vi
```
and bingo, we are allowed to use `vi`, so we should be able to run 
```
picoplayer@challenge:~$ sudo vi /root
" ============================================================================
" Netrw Directory Listing                                        (netrw v165)
"   /root
"   Sorted by      name
"   Sort sequence: [\/]$,\<core\%(\.\d\+\)\=\>,\.h$,\.c$,\.cpp$,\~\=\*$,*,\.o$,\.obj$,\.info$,\.swp$,\.bak$,\~$
"   Quick Help: <F1>:help  -:go up dir  D:delete  R:rename  s:sort-by  x:special
" ==============================================================================
../                                                                                                                     ./
.vim/
.bashrc
.flag.txt
.profile
.viminfo
```
thie file shows us a list of files inside the directory including a file called `.flag.txt` so we can run 

```
picoplayer@challenge:~$  sudo vi /root/.flag.txt
```
Which opens the file in vi and reveals the flag:
```
picoCTF{uS1ng_v1m_3dit0r_f6ad392b}
```