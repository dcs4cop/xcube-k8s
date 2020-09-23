## Installing xcube-gen

Copy values-example.yaml to values.yaml and adapt to ypi needs. 
After that run

```bash
kubectl create namespace xcube-gen
kubectl create -n xcube-geodb secret generic postgrest --from-file=postgrest.conf
kubectl create -n xcube-geodb secret generic postgrest-eodash --from-file=postgrest-eodash.conf=postgrest.conf

helm upgrade --install -n xcube-gen xcube-gen .
```

