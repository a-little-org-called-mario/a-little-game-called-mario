module.exports = async (github, context) => {
  var fs = require('fs');

  var names = '';

  for (let page = 1; ; page += 1) {
    var response = await github.repos.listContributors({
      owner: context.repo.owner,
      repo: context.repo.repo,
      per_page: 100,
      page: page
    });
    if (response.data.length == 0) {
      break;
    }
    for (const contributor of response.data) {
      if (contributor.type == 'User') {
        names += contributor.login + '\n';
      }
    }
  }

  fs.writeFileSync('credits.txt', names);
}
