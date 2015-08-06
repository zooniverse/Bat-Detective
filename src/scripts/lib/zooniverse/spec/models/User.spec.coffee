describe 'User', ->
  describe '.signIn', ->
    it 'does nothing if the user is alreday the current user'

    it 'sets the current user', ->

    it 'triggers "sign-in" with the new current user'

  describe '.signOut', ->
    it 'destroys the current user', ->

    it 'nullifies the current user', ->

  it 'signs in when Authentication triggers a login', ->

  it 'signs out when Authentication triggers a logout', ->