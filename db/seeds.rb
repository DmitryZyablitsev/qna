User.destroy_all
Question.destroy_all

test_user = User.create!(email: 'user@develop.com', password: '12345678')

programming_questions = test_user.questions.create!([
                                                      { title: 'rails_6', body: 'What JS working in rails 6?' },
                                                      { title: 'Slim', body: 'What Slim working in rails 6?' },
                                                      { title: 'Ruby 3.0.0',
                                                        body: 'What updated whis ruby 2.6 on 3.0.0' }
                                                    ])

programming_questions.first.answers.create!([
                                              { body: 'sdsfsfsfsdf', author: test_user },
                                              { body: 'aaaaaaaaaaa', author: test_user },
                                              { body: 'vvvvvvvvvvvv', author: test_user }
                                            ])
