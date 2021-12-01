const jwt = require("jsonwebtoken");

const config = process.env;

const verifyToken = (req, res, next) => {
  const token =
    req.body.token || req.query.token || req.headers["authorization"];

  if (!token) {
    return res.status(403).send("A token is required for authentication");
  }   
  try {
    const bearer = token.split(' ');
    if(bearer.length == 2)
    {
      const bearerToken = bearer[1];
      const decoded = jwt.verify(bearerToken, config.TOKEN_KEY);
      req.user = decoded;
    }
    else
    {
      const decoded = jwt.verify(token, config.TOKEN_KEY);
      req.user = decoded;
    }
  } catch (err) {
    return res.status(401).send("Invalid Token");
  }
  return next();
};

module.exports = verifyToken;