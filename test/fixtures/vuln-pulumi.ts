const bucket = new aws.s3.Bucket("b", { acl: "public-read" });
const fw = new aws.ec2.SecurityGroup("s", { ingress: { cidrBlocks: ["0.0.0.0/0"] } });
const db = new aws.rds.Instance("db", { tls: false });
