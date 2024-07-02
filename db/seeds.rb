User.destroy_all
Question.destroy_all

user, user2, user3 = User.create!([
                             { email: 'user@develop.com', password: '12345678', password_confirmation: '12345678', confirmed_at: Time.now },
                             { email: 'user2@develop.com', password: '12345678', password_confirmation: '12345678', confirmed_at: Time.now },
                             { email: 'user3@develop.com', password: '12345678', password_confirmation: '12345678', confirmed_at: Time.now },
                             { email: 'admin@develop.com', password: '12345678', password_confirmation: '12345678', confirmed_at: Time.now, admin: true }
                           ])

programming_questions = user3.questions.create!([
                                                 { title: 'rails_6', body: 'What JS working in rails 6?' },
                                                 { title: 'Slim', body: 'What Slim working in rails 6?' },
                                                 { title: 'Ruby 3.0.0',
                                                   body: 'What updated whis ruby 2.6 on 3.0.0' }
                                               ])

programming_questions.first.answers.create!([
                                              { body: 'sdsfsfsfsdf', author: user },
                                              { body: 'aaaaaaaaaaa', author: user3},
                                              { body: 'vvvvvvvvvvvv', author: user2 }
                                            ])

programming_questions.first.comments.create!([
  { body: 'comment_1', user: user },
  { body: 'comment_2', user: user }
])

programming_questions.first.links.create!([
  { name: 'MyLink', url: 'https://gist.github.com/DmitryZyablitsev/11b2834129c6e9897f680ae4fd6c59d8' },
  { name: 'MyLink2', url: 'https://thinknetica.com' }
])

