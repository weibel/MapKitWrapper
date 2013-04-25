##
# Dummy class used for tests
#
class TestSuiteDelegate
  ##
  # Attribute accessor
  #
  attr_accessor :window

  ##
  # Init App
  #
  def application(application, didFinishLaunchingWithOptions: launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = UIViewController.alloc.init
    true
  end
end