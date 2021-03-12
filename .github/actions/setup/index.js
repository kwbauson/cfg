const core = require('@actions/core')
try {
} catch (error) {
  core.setFailed(error.message)
}
