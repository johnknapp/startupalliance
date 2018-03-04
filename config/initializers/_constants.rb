RECAPTCHA_SITE              = '6LcfhSsUAAAAAKUUu0v5dd-YFBWq-qQ_nSBpjdAL'
RECAPTCHA_SECRET            = '6LcfhSsUAAAAAOOq8AAPIS9f1Sk3NKgxgQzUxVJ2'

PAGE_STATES                 = %w[Draft Published Flagged]

USER_STATES                 = %w[unconfirmed active paused]
USER_ROLES                  = %w[guest user admin]

SUBSCRIPTION_STATES         = %w[trialing active past_due canceled unpaid]

WEBRTC_PRIVATE_URL          = 'https://meet.jit.si/sa-pvo-'

ACCOUNT_ACTIVATION_TIP      = 'When you signed up, we sent you an account activation email containing a link to choose a username and password. Activate your account for full privileges!'
PRIVATE_ALLIANCE_TIP        = 'Uniting complementary groups of entrepreneurs to share advice, insight and feedback to help each other make better decisions, achieve goals, overcome challenges and improve outcomes.'
COLLABORATION_WORKSPACE_TIP = 'Where staff, advisors, consultants and investors team up to set objectives for their company, discuss and overcome challenges and track their progress towards their ultimate success.'
GETTING_STARTED_WEBCHAT_TIP = 'Members of each new Private Alliance and Company Workspace receive personalized advice in a free online meeting to get the most out of the platform right away.'
STEALTH_MODE_TIP            = 'In case you want to keep your Private Alliance and Company from appearing in directories and elsewhere on the site.'
SI_TI_TIP                   = 'Members rate themselves on 18 startup skills and 12 personal traits. (Except Associate Members.) We calculate a skill index (SI) and a trait index (TI) and display those on the site.'
STARTUP_SKILL_TIP           = 'Showcase your strengths using our standard set of 18 startup skills.'
PERSONAL_TRAIT_TIP          = 'Highlight your qualities using our standard set of 12 personal traits.'
VIRTUAL_OFFICE_TIP          = 'Web-based co-working using your webcam and microphone'
GVO_LINK_EXPIRY_TIP         = 'The link to the Global Virtual Office is updated each day at midnight UTC. The previous GVO link is available as a convenience.'
USER_TRAIT_TIP              = 'Only Personal Traits where you have rated yourself appear to others.'
VIEWER_TRAIT_TIP            = 'This member has rated themselves for these Personal Traits.'
USER_SKILL_TIP              = 'Only Startup Skills where you have rated yourself appear to others.'
VIEWER_SKILL_TIP            = 'This member has rated themselves for these Startup Skills.'
WEBRTC_TIP                  = 'We use WebRTC for real-time audio/video co-working. We recommend the Google Chrome browser.'
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
  change_plan
  change_plans
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
  gist
  gists
  help
  image
  images
  join_thanks
  join-thanks
  leader
  leaders
  leaderboard
  leaderboards
  meeting
  meetings
  member
  members
  message
  messages
  newrelic
  nucleus
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
  stripe
  stripes
  stripe_webhook
  stripe_webhooks
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
