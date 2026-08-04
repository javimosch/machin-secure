<template><div v-html="$rawHtml"></div></template>
<script>
redirect(req.query.url);
export default { runtimeConfig: { public: { secret: "key" } } }
</script>
<script>window.location = req.query.url; document.write(this.content);</script>
