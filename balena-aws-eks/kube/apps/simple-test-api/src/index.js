const restify = require('restify')
const restifyPlugins = require('restify').plugins
const corsMiddleware = require('restify-cors-middleware')
const Logger = require('logplease')
const logger = Logger.create('utils')
const { etagger, timestamp, fetchContent } = require('./util')()
const config = {
  name: "simple-test-api",
  version: "1.0.0",
  port: process.env.PORT || 3999
}
const cors = corsMiddleware({
  preflightMaxAge: 5, //Optional
  origins: ['https://*.kumpf.io', 'http://localhost:*'],
  allowHeaders: ['API-Token'],
  exposeHeaders: ['API-Token-Expiry']
})
const server = restify.createServer({
  name: config.name,
  version: config.version
})

server.pre(cors.preflight)
server.use(cors.actual)
server.use(restifyPlugins.jsonBodyParser({ mapParams: true }))
server.use(restifyPlugins.acceptParser(server.acceptable))
server.use(restifyPlugins.queryParser({ mapParams: true }))
server.use(restifyPlugins.fullResponse())
server.use(etagger().bind(server))

server.get('/', (req, res, next) => {
  const now = new Date().toISOString()

  const stat = {
    name: config.name,
    version: config.version,
    runtime: {
      env: 'node',
      version: process.version
    },
    current: now,
    endpoints: {
      getRoot: '/',
      fetchContent: '/seed/v1'
    }
  }

  logger.info(stat)
  res.send(stat)
  next()
})

server.get('/seed/v1', (req, res, next) => {
  fetchContent(req.url, (err, content) => {
    if (err) {
      logger.error(err)
      return next(err)
    }
    const ts = timestamp()
    req.id(ts.toString())
    res.end(`{"data": "${content}", "url": "${req.url}", "ts": ${ts}}`)
    next()
  })
})

server.listen(config.port, () => {
  logger.info(`Server is listening on http://localhost:${config.port}`)
})

