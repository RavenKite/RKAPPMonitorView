//
//  RKAPPMonitorView.m
//  RKAPPMonitorView
//
//  Created by 李沛倬 on 2018/3/29.
//

#import "RKAPPMonitorView.h"
#import <sys/sysctl.h>
#import <mach/mach.h>

#define isiPhoneX CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812))

@interface RKAPPMonitorView() {
    
    NSUInteger _count;
    
    NSTimeInterval _lastTime;
    
    CGPoint _origin;
}

@property (nonatomic, strong) CADisplayLink *link;

@property (nonatomic, strong) UILabel *contentLabel;

@end


@implementation RKAPPMonitorView

// MARK: - Life Cycle

- (instancetype)initWithOrigin:(CGPoint)origin {
    self = [super init];
    
    _origin = origin;
    
    [self initSubviews];
    
    return self;
}

- (void)dealloc {
    [self.link invalidate];
}

// MARK: - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentLabel.frame = CGRectMake(6, 4, self.bounds.size.width-6, self.bounds.size.height-8);
}


// MARK: - UI

- (void)initSubviews {
    
    [self configSelf];
    [self initContentLabel];
    
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)configSelf {
    
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = true;
    self.backgroundColor = [UIColor colorWithWhite:0.13 alpha:0.7];
    self.frame = CGRectMake(_origin.x, _origin.y, 105, 55);
}


- (void)initContentLabel {
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    [contentLabel sizeToFit];
    
    [self addSubview:contentLabel];
    
    self.contentLabel = contentLabel;
}


// MARK: - Action

- (void)tick:(CADisplayLink *)link {
    
    NSInteger fps = [self fps:link];
    if (fps == -1) { return; }
    
    NSAttributedString *attr = [self makeAttributedString:fps];
    
    self.contentLabel.attributedText = attr;
}


// MARK: - Touch Action

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    
    CGPoint currentPoint = [touch locationInView:self];
    CGPoint lastPoint = [touch previousLocationInView:self];
    CGPoint offsetPoint = CGPointMake(currentPoint.x - lastPoint.x, currentPoint.y - lastPoint.y);
    
    CGFloat topMargin = isiPhoneX ? 44 : 20;
    CGFloat bottomMargin = isiPhoneX ? 34 : 8;
    
    CGFloat offset_x = offsetPoint.x;
    if (self.frame.origin.x + offsetPoint.x <= 0) {
        offset_x = 0;
    } else if (self.frame.origin.x + self.frame.size.width + offsetPoint.x >= self.superview.frame.size.width) {
        offset_x = self.superview.frame.size.width - self.frame.origin.x - self.frame.size.width;
    }
    
    CGFloat offset_y = offsetPoint.y;
    if (self.frame.origin.y + offsetPoint.y <= topMargin) {
        offset_y = 0;
    } else if (self.frame.origin.y + self.frame.size.height + offsetPoint.y >= self.superview.frame.size.height - bottomMargin) {
        offset_y = self.superview.frame.size.height - bottomMargin - self.frame.origin.y - self.frame.size.height;
    }
    
    self.transform = CGAffineTransformTranslate(self.transform, offset_x, offset_y);
}


// MARK: - Setter && Getter

- (NSAttributedString *)makeAttributedString:(NSInteger)fps {
    CGFloat memoryUsage = [self memoryUsage];
    CGFloat totalMemory = [self memory];
    CGFloat CPUUsage = [self CPUPercentageUsage];
    
    UIColor *descColor = [UIColor whiteColor];
    NSAttributedString *fpsDescStr = [[NSAttributedString alloc] initWithString:@"FPS: " attributes:@{NSForegroundColorAttributeName: descColor}];
    NSAttributedString *cpuDescStr = [[NSAttributedString alloc] initWithString:@"\nCPU: " attributes:@{NSForegroundColorAttributeName: descColor}];
    NSAttributedString *memoryDescStr = [[NSAttributedString alloc] initWithString:@"\n内存: " attributes:@{NSForegroundColorAttributeName: descColor}];
    
    
    UIColor *fpsColor = [UIColor colorWithHue:0.27 * (fps/60.0 - 0.2) saturation:1 brightness:0.9 alpha:1];
    NSAttributedString *fpsStr = [[NSAttributedString alloc] initWithString:@(fps).stringValue attributes:@{NSForegroundColorAttributeName: fpsColor}];
    
    UIColor *cpuColor = [UIColor colorWithHue:0.27 * ((100-CPUUsage)/100.0 - 0.2) saturation:1 brightness:0.9 alpha:1];
    NSAttributedString *cpuStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f%%", CPUUsage] attributes:@{NSForegroundColorAttributeName: cpuColor}];
    
    UIColor *memoryColor = [UIColor colorWithHue:0.27 * ((totalMemory-memoryUsage)/totalMemory - 0.2) saturation:1 brightness:0.9 alpha:1];
    NSAttributedString *memoryStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1fMB", memoryUsage] attributes:@{NSForegroundColorAttributeName: memoryColor}];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:fpsDescStr];
    [attr appendAttributedString:fpsStr];
    [attr appendAttributedString:cpuDescStr];
    [attr appendAttributedString:cpuStr];
    [attr appendAttributedString:memoryDescStr];
    [attr appendAttributedString:memoryStr];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByClipping;
    [attr addAttributes:@{NSParagraphStyleAttributeName: style, NSFontAttributeName: self.font} range:NSMakeRange(0, attr.length)];
    
    return attr;
}

- (UIFont *)font {
    if (!_font) {
        _font = [UIFont systemFontOfSize:13];
    }
    
    return _font;
}


// MARK: - Private Method

- (NSInteger)fps:(CADisplayLink *)link {
    if (_lastTime == 0) {
        
        _lastTime = link.timestamp;
        return -1;
    }
    
    _count++;
    
    NSTimeInterval delta = link.timestamp - _lastTime;
    
    if (delta < 1) { return -1; }
    
    _lastTime = link.timestamp;
    
    float fps = _count / delta;
    
    _count = 0;
    
    return round(fps);
}

- (CGFloat)memoryUsage {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    
    kern_return_t kern = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    
    if (kern != KERN_SUCCESS) return 0;
    
    return info.resident_size / 1024.0 / 1024.0;
}

- (CGFloat)memory {
    size_t size = sizeof(int);
    
    long results;
    
    int mib[2] = {CTL_HW, HW_PHYSMEM};
    
    sysctl(mib, 2, &results, &size, NULL, 0);
    
    results = results / 1024 / 1024.0;
    
    return results;
}

- (CGFloat)CPUPercentageUsage {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return 0;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return 0;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return 0;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

@end
