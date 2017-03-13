module ApplicationHelper
  def home?
    controller_name == 'chords'
  end
  def sessions?
    controller_name == 'sessions'
  end
  def sections
    [
      {
        name: 'Chords',
        path: '/',
        active: home?
      },
      {
        name: 'Practice',
        path: '/sessions',
        active: sessions?
      }
    ]
  end
end
