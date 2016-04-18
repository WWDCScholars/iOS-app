//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

@import MapKit;
@class QCluster;

@interface ClusterAnnotationView : MKAnnotationView;

+(NSString*)reuseId;


-(instancetype)initWithCluster:(id)cluster;

@property(nonatomic, strong) id cluster;

@end