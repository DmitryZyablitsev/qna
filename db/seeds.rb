User.destroy_all
Question.destroy_all

user, user2, user3 = User.create!([
                             { email: 'user@develop.com', password: '12345678' },
                             { email: 'user2@develop.com', password: '12345678' },
                             { email: 'user3@develop.com', password: '12345678' }
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
