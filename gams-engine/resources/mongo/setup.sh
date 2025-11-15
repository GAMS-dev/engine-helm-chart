#!/bin/bash
cat << EOF | mongosh -u mongo_broker -p "$MONGO_INITDB_ROOT_PASSWORD"
db = db.getSiblingDB("gams_worker");

db.createRole({
  role: "job_watcher",
  roles: [],
  privileges: [
    {
      resource: {
        db: "gams_worker",
        collection: "fs.files"
      },
      actions: ["find", "update"],
    },
    {
      resource: {
        db: "gams_worker",
        collection: "hypercubes",
      },
      actions: ["find", "update"],
    },
    {
      resource: {
        db: "gams_worker",
        collection: "job_labels",
      },
      actions: ["find", "update"],
    }
  ],
});


db.createRole({
  role: "job_spawner",
  roles: [],
  privileges: [
    {
      resource: {
        db: "gams_worker",
        collection: "fs.files",
      },
      actions: ["find"],
    },
    {
      resource: {
        db: "gams_worker",
        collection: "job_labels",
      },
      actions: ["find", "update"],
    },
    {
      resource: {
        db: "gams_worker",
        collection: "instance_info",
      },
      actions: ["find"],
    },
    {
      resource: {
        db: "gams_worker",
        collection: "hypercubes",
      },
      actions: ["find", "update"],
    },
    {
      resource: {
        db: "gams_worker",
        collection: "dependencies",
      },
      actions: ["find", "remove"],
    },
  ],
});

db.createRole({
  role: "dependency_handler",
  roles: [],
  privileges: [
    {
      resource: {
        db: "gams_worker",
        collection: "dependencies",
      },
      actions: ["find", "update", "remove"],
    },
    {
      resource: {
        db: "gams_worker",
        collection: "hypercubes",
      },
      actions: ["update"],
    },
    {
      resource: {
        db: "gams_worker",
        collection: "engine_config",
      },
      actions: ["find"],
    },
  ],
});

db.createRole({
  role: "event_manager",
  roles: [],
  privileges: [
    {
      resource: {
        db: "gams_worker",
        collection: "hypercubes",
      },
      actions: ["find"],
    },
    {
      resource: {
        db: "gams_worker",
        collection: "engine_config",
      },
      actions: ["find"],
    },
  ],
});

db.createRole({
  role: "event_manager_role2",
  roles: [],
  privileges: [
    {
      resource: {
        db: "gams_worker",
        collection: "job_labels",
      },
      actions: ["find"],
    },
    {
      resource: {
        db: "gams_worker",
        collection: "webhook_events_disabled",
      },
      actions: ["find", "insert", "update"],
    },
    {
      resource: {
        db: "gams_worker",
        collection: "webpush_config",
      },
      actions: ["find", "insert"],
    },
    {
      resource: {
        db: "gams_worker",
        collection: "secrets",
      },
      actions: ["find"],
    },
  ],
});

db.createRole({
  role: "forward_proxy_role",
  roles: [],
  privileges: [
    {
      resource: {
        db: "gams_worker",
        collection: "engine_config",
      },
      actions: ["find"],
    },
  ],
});


db.createRole({
  role: "job_canceler",
  roles: [],
  privileges: [
    {
      resource: {
        db: "gams_worker",
        collection: "hypercubes",
      },
      actions: ["find", "update"],
    },
    {
      resource: {
        db: "gams_worker",
        collection: "dependencies",
      },
      actions: ["find", "remove"],
    },
  ],
});

db.createUser({
  user: "k8s_job_watcher",
  pwd: "${GMS_RUNNER_MONGO_K8S_JOB_WATCHER_PWD}",
  roles: ["job_watcher"],
});


db.createUser({
  user: "job_spawner",
  pwd: "${GMS_RUNNER_MONGO_SPWN_PWD}",
  roles: ["job_spawner"],
});

db.createUser({
  user: "dep_check",
  pwd: "${GMS_RUNNER_MONGO_DEPENDENCY_CHECK_PWD}",
  roles: ["dependency_handler"],
});

db.createUser({
  user: "event_manager",
  pwd: "${GMS_RUNNER_MONGO_EVENT_MANAGER_PWD}",
  roles: ["event_manager", "event_manager_role2"],
});

db.createUser({
  user: "forward_proxy",
  pwd: "${GMS_RUNNER_MONGO_FORWARD_PROXY_PWD}",
  roles: ["forward_proxy_role"],
});

db.createUser({
  user: "k8s_job_canceler",
  pwd: "${GMS_RUNNER_MONGO_K8S_CANCEL_PWD}",
  roles: ["job_canceler"],
});

db.namespaces.drop();
db.namespaces.createIndex({ name: 1 }, { unique: true });
db.namespaces.insertOne({ name: "global", permissions: {} });

db.instance_info.createIndex({ label: 1 }, { unique: true });

db.fs.files.createIndex(
  { filename: 1, "metadata.namespace_id": 1 },
  { unique: true }
);
db.fs.files.createIndex(
  {
    "metadata.submission_id": 1,
    "metadata.type": 1,
    "metadata.namespace_id": 1
  },
  {
    name: "files_subid_type_ns",
    partialFilterExpression: {
      "metadata.submission_id": { \$exists: true },
      "metadata.type": { \$exists: true }
    }
  }
);

db.secrets.drop();
db.secrets.createIndex({ type: 1 }, { unique: true });

db.job_labels.drop()
db.job_labels.createIndex({ submission_id: 1 });

db.schema_migrations.drop();
db.schema_migrations.insertOne({
  dirty: false,
  version: 11,
});

db.createUser({
  user: "mongo_broker",
  pwd: "${GMS_RUNNER_MONGO_BROKER_PWD}",
  roles: [
    {
      role: "readWrite",
      db: "gams_worker",
    },
  ],
});

db.createUser({
  user: "mongo_worker",
  pwd: "${GMS_RUNNER_MONGO_WORKER_PWD}",
  roles: [
    {
      role: "readWrite",
      db: "gams_worker",
    },
  ],
});

db.createUser({
  user: "stein",
  pwd: "${GMS_RUNNER_MONGO_HYPERCUBE_APPENDER_PWD}",
  roles: [
    {
      role: "readWrite",
      db: "gams_worker",
    },
  ],
});

db.createUser({
  user: "jack",
  pwd: "${GMS_RUNNER_MONGO_CLEANER_PWD}",
  roles: [
    {
      role: "readWrite",
      db: "gams_worker",
    },
  ],
});

db = db.getSiblingDB("test_gams_worker");

db.fs.files.createIndex({ markedAt: 1 }, { expireAfterSeconds: 1800 });
db.fs.chunks.createIndex({ markedAt: 1 }, { expireAfterSeconds: 1800 });

db.namespaces.drop();
db.namespaces.createIndex({ name: 1 }, { unique: true });
db.namespaces.insertOne({ name: "global", permissions: {} });

db.instance_info.createIndex({ label: 1 }, { unique: true });

db.fs.files.createIndex(
  { filename: 1, "metadata.namespace_id": 1 },
  { unique: true }
);

db.fs.files.createIndex(
  {
    "metadata.submission_id": 1,
    "metadata.type": 1,
    "metadata.namespace_id": 1
  },
  {
    name: "files_subid_type_ns",
    partialFilterExpression: {
      "metadata.submission_id": { \$exists: true },
      "metadata.type": { \$exists: true }
    }
  }
);

db.secrets.drop();
db.secrets.createIndex({ type: 1 }, { unique: true });

db.job_labels.drop()
db.job_labels.createIndex({ submission_id: 1 });


db.createRole({
  role: "dependency_handler",
  roles: [],
  privileges: [
    {
      resource: {
        db: "test_gams_worker",
        collection: "dependencies",
      },
      actions: ["find", "update", "remove"],
    },
    {
      resource: {
        db: "test_gams_worker",
        collection: "hypercubes",
      },
      actions: ["update"],
    },
    {
      resource: {
        db: "test_gams_worker",
        collection: "engine_config",
      },
      actions: ["find"],
    },
  ],
});

db.createRole({
  role: "event_manager",
  roles: [],
  privileges: [
    {
      resource: {
        db: "test_gams_worker",
        collection: "hypercubes",
      },
      actions: ["find"],
    },
    {
      resource: {
        db: "test_gams_worker",
        collection: "engine_config",
      },
      actions: ["find"],
    },
    {
      resource: {
        db: "test_gams_worker",
        collection: "job_labels",
      },
      actions: ["find"],
    },
    {
      resource: {
        db: "test_gams_worker",
        collection: "webhook_events_disabled",
      },
      actions: ["find", "insert", "update"],
    },
    {
      resource: {
        db: "test_gams_worker",
        collection: "webpush_config",
      },
      actions: ["find", "insert"],
    },
    {
      resource: {
        db: "test_gams_worker",
        collection: "secrets",
      },
      actions: ["find"],
    },
  ],
});

db.createRole({
  role: 'forward_proxy_role',
  roles: [],
  privileges: [
    {
      resource: {
        db: 'test_gams_worker',
        collection: 'engine_config',
      },
      actions: ['find'],
    },
  ],
});

db.createUser({
  user: "dep_check",
  pwd: "${GMS_RUNNER_MONGO_DEPENDENCY_CHECK_PWD}",
  roles: ["dependency_handler"],
});

db.createUser({
  user: "event_manager",
  pwd: "${GMS_RUNNER_MONGO_EVENT_MANAGER_PWD}",
  roles: ["event_manager"],
});

db.createUser({
  user: 'forward_proxy',
  pwd: "${GMS_RUNNER_MONGO_FORWARD_PROXY_PWD}",
  roles: ['forward_proxy_role'],
});

db.createUser({
  user: "mongo_broker",
  pwd: "${GMS_RUNNER_MONGO_BROKER_PWD}",
  roles: [
    {
      role: "readWrite",
      db: "test_gams_worker",
    },
  ],
});

db.createUser({
  user: "mongo_worker",
  pwd: "${GMS_RUNNER_MONGO_WORKER_PWD}",
  roles: [
    {
      role: "readWrite",
      db: "test_gams_worker",
    },
  ],
});

db.createUser({
  user: "stein",
  pwd: "${GMS_RUNNER_MONGO_HYPERCUBE_APPENDER_PWD}",
  roles: [
    {
      role: "readWrite",
      db: "test_gams_worker",
    },
  ],
});

db.createUser({
  user: "jack",
  pwd: "${GMS_RUNNER_MONGO_CLEANER_PWD}",
  roles: [
    {
      role: "readWrite",
      db: "test_gams_worker",
    },
  ],
});
EOF

echo "Hello world"
