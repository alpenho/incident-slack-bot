class Incident < ApplicationRecord
  validates_presence_of :title

  enum severity: {
    sev0: 0,
    sev1: 1,
    sev2: 2
  }
end
