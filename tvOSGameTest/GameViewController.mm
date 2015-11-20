//
//  GameViewController.m
//  tvOSGameTest
//
//  Created by Hernan Saez on 11/20/15.
//  Copyright (c) 2015 Hernan Saez. All rights reserved.
//

#import "GameViewController.h"

using namespace crimild;

SharedPointer< Node > buildLight( const Quaternion4f &rotation, const RGBAColorf &color, float major, float minor, float speed )
{
    auto orbitingLight = crimild::alloc< Group >();
    
    auto primitive = crimild::alloc< SpherePrimitive >( 0.05f );
    auto geometry = crimild::alloc< Geometry >();
    geometry->attachPrimitive( primitive );
    
    auto material = crimild::alloc< Material >();
    material->setDiffuse( color );
   	material->setProgram( AssetManager::getInstance()->get< ShaderProgram >( Renderer::SHADER_PROGRAM_UNLIT_DIFFUSE ) );
    geometry->getComponent< MaterialComponent >()->attachMaterial( material );
    
    orbitingLight->attachNode( geometry );
    
    auto light = crimild::alloc< Light >();
    light->setColor( color );
    orbitingLight->attachNode( light );
    
    auto orbitComponent = crimild::alloc< OrbitComponent >( 0.0f, 0.0f, major, minor, speed );
    orbitingLight->attachComponent( orbitComponent );
    
    auto group = crimild::alloc< Group >();
    group->attachNode( orbitingLight );
    group->local().setRotate( rotation );
    
    return group;
}

SharedPointer< Node > buildScene(float width, float heigth)
{
    auto trefoilKnot = crimild::alloc< Geometry >();
    auto trefoilKnotPrimitive = crimild::alloc< TrefoilKnotPrimitive >( Primitive::Type::TRIANGLES, 1.0, VertexFormat::VF_P3_N3 );
    trefoilKnot->attachPrimitive( trefoilKnotPrimitive );
    
    auto material = crimild::alloc< Material >();
    material->setAmbient( RGBAColorf( 0.0f, 0.0f, 0.0f, 1.0f ) );
    material->setDiffuse( RGBAColorf( 1.0f, 1.0f, 1.0f, 1.0f ) );
    trefoilKnot->getComponent< MaterialComponent >()->attachMaterial( material );
    
    auto scene = crimild::alloc< Group >();
    scene->attachNode( trefoilKnot );
    
    scene->attachNode( buildLight(
                                  Quaternion4f::createFromAxisAngle( Vector3f( 0.0f, 1.0f, 1.0 ).getNormalized(), Numericf::HALF_PI ),
                                  RGBAColorf( 1.0f, 0.0f, 0.0f, 1.0f ),
                                  -1.0f, 1.25f, 0.95f ).get() );
    
    scene->attachNode( buildLight(
                                  Quaternion4f::createFromAxisAngle( Vector3f( 0.0f, 1.0f, -1.0 ).getNormalized(), -Numericf::HALF_PI ),
                                  RGBAColorf( 0.0f, 1.0f, 0.0f, 1.0f ),
                                  1.0f, 1.25f, -0.75f ).get() );
    
    scene->attachNode( buildLight(
                                  Quaternion4f::createFromAxisAngle( Vector3f( 0.0f, 1.0f, 0.0 ).getNormalized(), Numericf::HALF_PI ),
                                  RGBAColorf( 0.0f, 0.0f, 1.0f, 1.0f ), 
                                  1.25f, 1.0f, -0.85f ).get() );
    
    auto camera = crimild::alloc< Camera >( 45.0f, width / heigth, 0.1f, 1024.0f );
    camera->local().setTranslate( 0.0f, 0.0f, 3.0f );
    scene->attachNode( camera );
    
    return scene;
}

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    auto sim = self.simulation;
    sim->setScene(buildScene(self.view.bounds.size.width, self.view.bounds.size.height));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
