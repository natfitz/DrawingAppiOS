//
//  Shader.fsh
//  simpleDrawing2
//
//  Created by Nathan Fitzgibbon on 11/6/13.
//  Copyright (c) 2013 Nathan Fitzgibbon. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
