Posts.allow(["*"]);
Meteor.publish("posts", function() { return Posts.find(); });
