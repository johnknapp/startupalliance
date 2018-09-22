ENTPRENEUR_YEAR_MTHLY       = '$4.95'   # deprecating the entrepreneur plans
ENTPRENEUR_MONTH            = '$7.95'   # deprecating the entrepreneur plans
ENTPRENEUR_YEAR             = '$59.40'  # deprecating the entrepreneur plans
ALLIANCE_YEAR_MTHLY         = '$7.95'   # keeping same price for charter tier
ALLIANCE_MONTH              = '$10.95'  # keeping same price for charter tier
ALLIANCE_YEAR               = '$95.40'  # keeping same price for charter tier
ALLIANCE_YEAR_SAVINGS       = '$36'
COMPANY_YEAR_MTHLY          = '$29.95'  # raising pricing from intro to charter tier
COMPANY_YEAR_SAVINGS        = '$240'
COMPANY_MONTH               = '$49.95'  # raising pricing from intro to charter tier
COMPANY_YEAR                = '$359.40' # raising pricing from intro to charter tier
# COMPANY_YEAR_MTHLY          = '$9.95'
# COMPANY_MONTH               = '$12.95'
# COMPANY_YEAR                = '$119.40'

RELEVANT_STRIPE_WEBHOOKS    = %w[
  customer.subscription.created
  customer.subscription.trial_will_end
  invoice.created
  invoice.payment_succeeded
  invoice.payment_failed
  customer.subscription.deleted
  customer.subscription.updated
]
VALID_STRIPE_COUPONS        = %w[
  VIP6JK
  charter6
  beta6
]
STRIPE_PK_LIVE              = 'pk_live_ZnTO2YN1mMhQy09vNOUp5Sgc'
STRIPE_PK_TEST              = 'pk_test_As4q7e0EyphQP9ncUqCCBlPJ'

RECAPTCHA_SITE              = '6LcfhSsUAAAAAKUUu0v5dd-YFBWq-qQ_nSBpjdAL'
RECAPTCHA_SECRET            = '6LcfhSsUAAAAAOOq8AAPIS9f1Sk3NKgxgQzUxVJ2'

QUARK_STATES                = %w[Contributed Approved Promoted Flagged]
EVENT_STATES                = %w[Proposed Approved Promoted Flagged]

PLAN_STATES                 = %w[active inactive]
PAGE_STATES                 = %w[Draft Suggestion Published Flagged]

USER_STATES                 = %w[unconfirmed active paused]
USER_ROLES                  = %w[guest user admin]
WORK_ROLE                   = %w[Owner Marketing Sales Technical Operations Advisor Investor Other Unset]

SUBSCRIPTION_STATES         = %w[trialing active past_due canceled unpaid error]

WEBRTC_PRIVATE_URL          = 'https://meet.jit.si/sa-pvo-'
WEBRTC_EVENT_URL            = 'https://meet.jit.si/sa-event-'

TOP_QUARK_TIP               = 'This is a Top Quark! Our Top Quark Award honors the best pearls of startup wisdom contributed by our members. Top Quarks and the author may be promoted on social channels.'
KB_SUGGESTION_TIP           = 'Suggested Knowledge Base Pages are marked with a Bell icon as a signal to potential authors they have a writing opportunity.'
ACCOUNT_ACTIVATION_TIP      = 'When you signed up, we sent you an account activation email containing a link to choose a username and password. Activate your account for full privileges!'
ENTREPRENEURS_NUCLEUS_TIP   = 'The Entrepreneur’s Nucleus™ is our collection of free community resources where you can ask questions, get answers, advice, hard-won knowledge and startup wisdom.'
ENTREPRENEUR_JET_FUEL_TIP   = 'Ultra low-cost personal subscription for entrepreneurs who want to get the most from our entrepreneurial community.'
PRIVATE_ALLIANCE_TIP        = 'Where small groups of entrepreneurs come together to share advice, insight and feedback to help each other make better decisions, achieve goals, overcome challenges and improve outcomes.'
COLLABORATION_WORKSPACE_TIP = 'Where staff, advisors, consultants and investors team up to set objectives for their company, discuss and overcome challenges and track their progress towards their ultimate success.'
CONCIERGE_ONBOARDING_TIP    = 'Private Alliance and Company Workspace members receive concierge onboarding to come up to speed quickly and get the most from the platform.'
STEALTH_MODE_TIP            = 'In case you want to keep your Private Alliance and Company from appearing in directories and elsewhere on the site.'
SI_TI_TIP                   = 'Members rate themselves on 18 startup skills and 12 personal traits. We calculate their skill index (SI) and trait index (TI) and display SI/TI values beside their name.'
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
COMPANY_TIP_EMAIL           = 'I found StartupAlliance.com, they have a Company Workspace that looks perfect for our team. I think we should try it out.'
ALLIANCE_TIP_EMAIL          = 'StartupAlliance.com Private Alliances are a great way to help us collaborate and help each other. I think we should try it out.'

USERNAME_EXCLUSIONS = %w[
  about
  accept
  admin
  administrator
  alliance
  alliances
  card
  cards
  change_plan
  change_plans
  code_of_conduct
  company
  companies
  compare_plans
  content
  conversation
  conversations
  discussion
  discussions
  event
  events
  faq
  factor
  factors
  fast
  fastr
  fasts
  feature
  features
  gist
  gists
  help
  image
  images
  thanks_join
  join-thanks
  leader
  leaders
  leaderboard
  leaderboards
  meeting
  meetings
  member
  members
  membership
  memberships
  message
  messages
  newrelic
  nucleus
  offer
  offers
  okr
  okrs
  privacy
  private
  quark
  quarks
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
  subscriber
  subscribers
  resource
  resources
  resque
  room
  rooms
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
  vie
  vip
  vips
  webhook
  webhooks
  welcome
  wizard
  wizards
]
