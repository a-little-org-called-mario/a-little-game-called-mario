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

    const nameStrings = await Promise.all(
      response.data
        .filter(contributor => contributor.type === 'User')
        .map(async contributor => {
          const res = await github.users.getByUsername({
            username: contributor.login,
          });

          const { name, login } = res.data;

          if (!name) {
            return `${login}\n`;
          }

          return `${name} (${login})\n`;
        })
    );

    nameStrings.forEach(name => names += name);
  }

  fs.writeFileSync('credits.txt', names);
}
