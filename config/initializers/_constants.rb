RECAPTCHA_SITE              = '6LcfhSsUAAAAAKUUu0v5dd-YFBWq-qQ_nSBpjdAL'
RECAPTCHA_SECRET            = '6LcfhSsUAAAAAOOq8AAPIS9f1Sk3NKgxgQzUxVJ2'

USER_STATES               = %w[unconfirmed active paused]
USER_ROLES                  = %w[guest user admin]
USER_PLANS                  = %w[associate alliance company]

PRIVATE_ALLIANCE_TIP        = 'Uniting complementary groups of entrepreneurs to share advice, insight and feedback to help each other make better decisions, achieve goals, overcome challenges and improve outcomes.'
COLLABORATION_WORKSPACE_TIP = 'Where staff, advisors, consultants and investors team up to set objectives for their company, discuss and overcome challenges and track their progress towards their ultimate success.'
STEALTH_MODE_TIP            = 'In case you want to keep your Private Alliance and Company from appearing in directories and elsewhere on the site.'
STARTUP_SKILL_TIP           = 'Showcase your strengths using our standard set of 18 startup skills.'
PERSONAL_TRAIT_TIP          = 'Highlight your qualities using our standard set of 12 personal traits.'
VIDEO_CONFERENCE_TIP        = 'Conduct private online video meetings whenever you want with people from all around the world.'
USER_TRAIT_TIP              = 'Only Personal Traits where you have rated yourself appear to others. Or hide them in your account settings.'
VIEWER_TRAIT_TIP            = 'This member has rated themselves for these Personal Traits.'
USER_SKILL_TIP              = 'Only Startup Skills where you have rated yourself appear to others. Or hide them in your account settings.'
VIEWER_SKILL_TIP            = 'This member has rated themselves for these Startup Skills.'
WEBRTC_TIP                  = 'We use WebRTC for live audio/video conferencing. We recommend the Google Chrome browser.'
OKR_TIP                     = 'Companies use our Objectives and Key Results tool to set and achieve goals and communicate priorities throughout the company'
FAST_TIP                    = 'Companies use our FActors & STrategies tool to keep the team focused on overall priorities and optimal strategies'
SAKPI_SHORT_TIP             = 'Startup Alliance Key Performance Indicators are tracked and optimized by the company team.'
SAKPI_TIP                   = 'Startup Alliance Key Performance Indicators are tracked and optimized by the company team. The level indicates relative strength of each SAKPI. (Visible only to company teams.)'

USERNAME_EXCLUSIONS = %w[
  accept
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
  factor
  factors
  fast
  fastr
  fasts
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
  split
  splits
  startupalliance
  strategy
  strategies
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
