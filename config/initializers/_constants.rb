USER_STATES               = %w[unconfirmed active paused]
USER_ROLES                = %w[guest user partner advisor admin]

COMPANY_STATES            = %w[initialized active paused]
OKR_STATES                = %w[initialized active paused]
ALLIANCE_STATES           = %w[initialized active paused]

USER_TRAIT_TIP            = 'Only Traits where you have rated yourself appear to others.'
VIEWER_TRAIT_TIP          = 'This member has rated themselves for these Traits.'
USER_SKILL_TIP            = 'Only Tkills where you have rated yourself appear to others.'
VIEWER_SKILL_TIP          = 'This member has rated themselves for these Skills.'
WEBRTC_TIP                = 'WebRTC is live audio/video chat, available on supported browsers only.'
OKR_TIP                   = 'Companies use our Objectives and Key Results tool to set and achieve their goals'
SAKPI_TIP                 = 'Startup Alliance Key Performance Indicators are tracked and optimized by the company team.'
SAKPI_LEVEL_TIP           = 'The level indicates relative strength of each Performance Indicator.'

USERNAME_EXCLUSIONS = %w[
  about
  admin
  administrator
  alliance
  alliances
  code_of_conduct
  company
  companies
  content
  faq
  help
  image
  images
  join_thanks
  join-thanks
  meeting
  meetings
  member
  members
  newrelic
  okr
  okrs
  privacy
  sandbox
  sandboxes
  sidekiq
  sidekiq
  split
  splits
  startupalliance
  resource
  resources
  resque
  user
  users
  username
  usernames
  user_name
  user_names
  user-name
  user-names
  terms
  terms_of_service
  terms-of-service
  tos
  terms_of_use
  terms-of-use
  wizard
  wizards
]
