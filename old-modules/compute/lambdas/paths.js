exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request;
  const uri = request.uri;

  // Redirect some popular search results to their new pages
  const redirects = [
    { test: /^\/contact-us\/?$/g, targetURI: "/contact/" },
    { test: /^\/about-peter\/?$/g, targetURI: "/about/" },
    { test: /^\/test-redirect\/?$/g, targetURI: "/about/" },
    { test: /^\/redirection\/?$/g, targetURI: "/contact/" }
  ];

  const buckets = [
    {
      bucketName: "gatsby.dev.aws.reidweb.com.s3.amazonaws.com",
      primaryHost: "gatsby.dev.aws.reidweb.com"
    },
    {
      bucketName: "gatsby.np.aws.reidweb.com.s3.amazonaws.com",
      primaryHost: "gatsby.np.aws.reidweb.com"
    },
    {
      bucketName: "gatsby.prod.aws.reidweb.com.s3.amazonaws.com",
      primaryHost: "reidweb.com"
    }
  ];
  const redirect = redirects.find(r => uri.match(r.test));
  if (redirect) {
    const host = buckets.find(b => b.bucketName === request.headers.host[0].value);
    const newLocation = `https://${host.primaryHost}${redirect.targetURI}`;
    const response = {
      status: "301",
      statusDescription: "Moved Permanently",
      headers: {
        location: [
          {
            key: "Location",
            value: newLocation
          }
        ]
      }
    };

    console.log(`INFO:Redirecting user to: ${newLocation}`);
    callback(null, response);
    return;
  }

  // Make sure directory requests serve index.html
  if (uri.endsWith("/")) {
    request.uri += "index.html";
  } else if (!uri.includes(".")) {
    request.uri += "/index.html";
  }

  callback(null, request);
};
