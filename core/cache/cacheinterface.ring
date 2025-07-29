# ======================================
# RingWeb Framework
# Cache Interface Class
# ======================================

Package System.RingWeb

Class CacheInterface
    func getValue cKey
    func setValue cKey, xValue, nMinutes
    func hasValue cKey
    func removeValue cKey
    func clear
