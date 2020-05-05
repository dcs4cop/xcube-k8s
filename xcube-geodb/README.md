## Installing xcube-gen

Copy values-example.yaml to values.yaml and adapt to ypi needs. 
After that run

```bash
kubectl create namespace xcube-gen
helm upgrade --install -n xcube-gen xcube-gen .
```