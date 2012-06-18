#import <UIKit/UIKit.h>

extern "C" {
    void ruby_sysinit(int *, char ***);
    void ruby_init(void);
    void ruby_init_loadpath(void);
    void ruby_script(const char *);
    void ruby_set_argv(int, char **);
    void rb_vm_init_compiler(void);
    void rb_vm_init_jit(void);
    void rb_vm_aot_feature_provide(const char *, void *);
    void *rb_vm_top_self(void);
    void rb_rb2oc_exc_handler(void);
    void rb_exit(int);
void MREP_2AD45128D9344932A6686F2A227CBBAA(void *, void *);
void MREP_66B21A64A0E84F318E8A047C68958ABE(void *, void *);
void MREP_8ADDCEF9339C4318988B9E6B8DE50A71(void *, void *);
void MREP_35298CBDD8BA4E689E8DAA4BA4BD922C(void *, void *);
}
@interface SpecLauncher : NSObject
@end

@implementation SpecLauncher

+ (id)launcher
{
    [UIApplication sharedApplication];
    SpecLauncher *launcher = [[self alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:launcher selector:@selector(appLaunched:) name:UIApplicationDidBecomeActiveNotification object:nil];
    return launcher; 
}

- (void)appLaunched:(id)notification
{
    // Give a bit of time for the simulator to attach...
    [self performSelector:@selector(runSpecs) withObject:nil afterDelay:0.1];
}

- (void)runSpecs
{
MREP_8ADDCEF9339C4318988B9E6B8DE50A71(self, 0);
MREP_35298CBDD8BA4E689E8DAA4BA4BD922C(self, 0);
[NSClassFromString(@"Bacon") performSelector:@selector(run)];
}

@end
int
main(int argc, char **argv)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    const char *progname = argv[0];
    ruby_init();
    ruby_init_loadpath();
    ruby_script(progname);
    int retval = 0;
    try {
        void *self = rb_vm_top_self();
[SpecLauncher launcher];
MREP_2AD45128D9344932A6686F2A227CBBAA(self, 0);
MREP_66B21A64A0E84F318E8A047C68958ABE(self, 0);
        retval = UIApplicationMain(argc, argv, nil, @"TestSuiteDelegate");
        rb_exit(retval);
    }
    catch (...) {
	rb_rb2oc_exc_handler();
    }
    [pool release];
    return retval;
}
