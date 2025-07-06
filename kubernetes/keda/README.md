# Tutorial: Autoscaling with KEDA on AKS

This tutorial will guide you through setting up a simple autoscaled application based on PostgreSQL queries.

## Creating / Updating the Cluster

Use this command to create an AKS cluster with KEDA enabled:

```bash
az aks create --resource-group myResourceGroup --name myAKSCluster --enable-keda
```

Or you can enable it on an existing cluster:

```bash
az aks update --resource-group myResourceGroup --name myAKSCluster --enable-keda
```

## Setting up the Database

Install the EDB Operator to allow the creation of databases:

```bash
kubectl apply -f https://get.enterprisedb.io/cnp/postgresql-operator-1.22.0.yaml
```

Then apply the `database.yaml`:

```bash
kubectl apply -f database.yaml
```

After creating the database, let's populate it with some data.

Start by connecting to the pod and running some commands in `psql`:

```bash
kubectl exec -it --namespace kedapoc kedapoc-database-1 -- bash
psql
\c app
```
```
CREATE SCHEMA IF NOT EXISTS queue;
CREATE TABLE IF NOT EXISTS queue.messages (id SERIAL PRIMARY KEY, status VARCHAR(50));
GRANT USAGE ON SCHEMA queue TO app;
GRANT SELECT ON queue.messages TO app;
```

Now that the tables are created, we can add some data. This will create a simulated message queue with 100 messages in it.

### Insert Messages into the Queue

```sql
DO
$$
BEGIN
  FOR counter IN 1..100 LOOP
    INSERT INTO queue.messages (status) VALUES ('new');
  END LOOP;
END
$$;
```

---

### Verify Message Count in Queue

To verify the number of messages in the queue:

```sql
SELECT count(*) FROM queue.messages WHERE status = 'new';
```

This is the number that we'll base the **scaling trigger** on.

### Deploying Our Application And Scaling It Up

This is the number that we'll base the scaling trigger on.

#### First, we need to get hold of the password for the database:

```bash
kubectl get secret kedapoc-database-app -n kedapoc -o jsonpath='{.data.password}' | base64 --decode
```

Modify the deployment.yaml and add the password you retrieved in the step above.

#### Now we're ready to deploy our application:

```bash
kubectl apply -f deployment.yaml
```

# Verifying and Scaling Our Deployment

With `kubectl get pods -n kedapoc` you can verify that we now have a deployment with 1 replica and a database with 3 replicas running.

```
NAME                            READY   STATUS    RESTARTS   AGE
httpd-frontend-5c57cfb89-blwnn   1/1     Running   0          9s
kedapoc-database-1               1/1     Running   0          4m3s
kedapoc-database-2               1/1     Running   0          2m3s
kedapoc-database-3               1/1     Running   0          69s
```

## Now we're ready to apply our scaled object:

```bash
kubectl apply -f keda.yaml
```

## Check the status of the scaled object with the following command:

```bash
 kubectl get scaledobjects.keda.sh -n kedapoc
```

# Scaling down

Now let's simulate that our message queue is empty.

## To delete all messages:

```sql
DELETE FROM queue.messages;
```

It might take some time, but after a while the deployment should scale back down to 1 replica.

# Conclusion

Congratulations! You have successfully scaled your first application with KEDA!