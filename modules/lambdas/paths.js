exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request;

  // Redirect some popular search results to their new pages
  const redirects = [
    { test: /^\/contact-us\/?$/g, targetURI: "/contact/" },
    { test: /^\/about-peter\/?$/g, targetURI: "/about/" },
    { test: /^\/test-redirect\/?$/g, targetURI: "/about/" },
    { test: /^\/redirection\/?$/g, targetURI: "/contact/" }
  ];

  const redirect = redirects.find(r => request.uri.match(r.test));
  if (redirect) {
    request.uri = redirect.targetURI;
  }

  // Make sure directory requests serve index.html
  if (request.uri.endsWith("/")) {
    request.uri += "index.html";
  } else if (!request.uri.includes(".")) {
    request.uri += "/index.html";
  }

  callback(null, request);
};
