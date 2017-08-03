RECAPTCHA_SITE            = '6LcfhSsUAAAAAKUUu0v5dd-YFBWq-qQ_nSBpjdAL'
RECAPTCHA_SECRET          = '6LcfhSsUAAAAAOOq8AAPIS9f1Sk3NKgxgQzUxVJ2'

USER_STATES               = %w[unconfirmed active paused]
USER_ROLES                = %w[guest user admin]
USER_PLANS                = %w[associate alliance company]

COMPANY_STATES            = %w[initialized active paused]
OKR_STATES                = %w[initialized active paused]
ALLIANCE_STATES           = %w[initialized active paused]

PRIVATE_ALLIANCE_TIP      = 'Where entrepreneurs collaborate to achieve goals, overcome challenges, expand networks and maximize success.'
STEALTH_MODE_TIP          = 'In case you want to keep your Private Alliances and Companies from appearing in search results.'
STARTUP_SKILL_TIP         = 'Showcase your strengths using our standard set of 18 startup skills.'
PERSONAL_TRAIT_TIP        = 'Highlight your qualities using our standard set of 12 personal traits.'
VIDEO_CONFERENCE_TIP      = 'Conduct private online video meetings whenever you want with people from all around the world.'
USER_TRAIT_TIP            = 'Only Personal Traits where you have rated yourself appear to others.'
VIEWER_TRAIT_TIP          = 'This member has rated themselves for these Personal Traits.'
USER_SKILL_TIP            = 'Only Startup Skills where you have rated yourself appear to others.'
VIEWER_SKILL_TIP          = 'This member has rated themselves for these Startup Skills.'
WEBRTC_TIP                = 'WebRTC is live audio/video chat, available on supported browsers only.'
OKR_TIP                   = 'Companies use our Objectives and Key Results tool to set and achieve their goals'
SAKPI_SHORT_TIP           = 'Startup Alliance Key Performance Indicators are tracked and optimized by the company team.'
SAKPI_TIP                 = 'Startup Alliance Key Performance Indicators are tracked and optimized by the company team. The level indicates relative strength of each SAKPI.'
SAKPI_LEVEL_TIP           = 'The level indicates relative strength of each SAKPI. Only visible to company team.'

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
  conversation
  conversations
  discussion
  discussions
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
  message
  messages
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
