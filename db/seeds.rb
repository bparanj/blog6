User.create email: 'brianna@zepho.com', password: 'password', password_confirmation: 'password'

user = User.new email: 'mary@example.com', password: 'guessit', password_confirmation: 'guessit'
user.save 

Category.create [
  {name: 'Programming'},
  {name: 'Event'},
  {name: 'Travel'},
  {name: 'Music'},
  {name: 'TV'}
]

articles = Article.create([
  {
    title: 'Advanced Active Record',
    body: "Models need to relate to each other. In the real world, ..",
    published_at: Date.today,
  },
  {
    title: 'One-to-many associations',
    body: "One-to-many associations describe a pattern ..",
    published_at: Date.today
  },
  {
    title: 'Associations',
    body: "Active Record makes working with associations easy..",
    published_at: Date.today
  },
])

user.articles << articles
user.save