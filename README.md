# AutoPilot Pattern Mongo Express

*An example implementation of a simple MongoDB application ([Mongo Express](https://github.com/mongo-express/mongo-express)) on top of [AutoPilot Pattern MongoDB](https://github.com/autopilotpattern/mongodb)*

## Architecture

A running cluster includes the following components:
- [AutoPilot Pattern MongoDB](https://github.com/autopilotpattern/mongodb): for auto-scaling MongoDB via replica sets
- [ContainerPilot](https://www.joyent.com/containerpilot): included in our Mongo Express container to coordinate runtime configuration rewriting after cluster changes
- [Consul](https://www.consul.io/): used to coordinate replication and failover
- [Mongo Express](https://github.com/mongo-express/mongo-express): a simple MongoDB application for browsing/editing the data stored in our cluster

## Running the cluster

Starting a new cluster is easy once you have [your `_env` file set with the configuration details](#configuration)

**Triton**
- `./setup.sh`
- `docker-compose up -d`
- `open http://$(triton ip mongoexpress_mongo-express_1):8081`

**Local (or Non-Triton)**
- `docker-compose up -f local-compose.yml -d`
- `open http://localhost:8081`

The `setup.sh` script will check that your environment is setup correctly and will create an `_env` file that includes injecting an environment variable for the Consul hostname into the Mongo and Mongo-Express containers so we can take advantage of [Triton Container Name Service (CNS)](https://www.joyent.com/blog/introducing-triton-container-name-service).

The MongoDB cluster will be initialized according to the process outlined in the [AutoPilot Pattern MongoDB README](https://github.com/autopilotpattern/mongodb/tree/master/README.md), and Mongo Express will be configured to point at all active MongoDB nodes in the cluster (via Consul and ContainerPilot).

**Run `docker-compose -f local-compose.yml scale mongodb=2` to add a replica (or more than one!)**. The replicas will automatically be added to the replica set on the master and will register themselves in Consul as replicas once they're ready, and the Mongo Express configuration will be reloaded to point to the new replicas.

### Configuration

The [configuration items noted for AutoPilot Pattern MongoDB](https://github.com/autopilotpattern/mongodb#configuration) apply for this image as well as the following explicit parameters for this implementation (passed in via `_env` file next to `docker-compose.yml` and `local-compose.yml`):

- `CONSUL` (optional): when using `local-compose.yml`, this will default to `consul` (and thus use the DNS provided by Docker), but for deploying on Triton via `docker-compose.yml`, this should be set to [the CNS path of the `consul` service (`consul.svc.XXX...`)](https://docs.joyent.com/public-cloud/network/cns)
- any Mongo Express environment variables, such as `ME_CONFIG_OPTIONS_EDITORTHEME` or `ME_CONFIG_MONGODB_ENABLE_ADMIN`; see [the Mongo Express documentation](https://www.npmjs.com/package/mongo-express#usage-docker) for a more complete list

### Sponsors

Initial development of this project was sponsored by [Joyent](https://www.joyent.com).
