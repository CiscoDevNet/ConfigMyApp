---
sort: 1

---

# Common Examples 

This section contains examples of running an instance of ConfigMyApp, it should be adjusted to fit your use-case and here are some of the common ones:


> Server visibility

```
./start.sh --application-name <app-name> --include-sim
```

> Database visibility

```
./start.sh --application-name <app-name> --include-database  ---database=’DB collector name’
```

> Health rules

```bash
./start.sh --application-name <app-name>  --no-overwrite-health-rules
```

> Business transactions

```bash
./start.sh --application-name <app-name>  --configure-bt
```

```bash
./start.sh --application-name <app-name>  ---bt-only
```

> Full configuration parameters

```bash
./start.sh --application-name <app-name>  \ 
           -c "http://customer1.saas.appdynamics.com" \ 
           -P “8090” \ 
           --account customer1 \
           -p "<password>" \ 
           --use-encoded-credentials \
           -u "username" \ 
           --configure-bt \
           --include-database \
           --database-name 'DB Collector Name' \
           --include-sim  \ 
           --use-https false  \ 
           --proxy-url localhost  \
           --proxy-port 3303  \ 
           --overwrite-health-rules 
                  
```

> Action suppression

```bash
./start.sh --suppress-action \ 
           --suppress-name=MaintainanceWindowThisWeekend \ 
           --suppress-start=2020-08-31T12:00:00+0000 \ 
           --suppress-duration=360
```
