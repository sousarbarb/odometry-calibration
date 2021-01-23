function [RobotParam] = readRobotParametersMetadata(filename)

  % Initialization
  metadataCell = readcell(filename);
  metadataMat  = readmatrix(filename);
  
  % Robot Parameters
  RobotParam.type   = metadataCell{1,2};  % Type of the robot: 'diff'
  RobotParam.ngear  = metadataMat(1,2);   % Reduction ratio (n:1)
  RobotParam.encRes = metadataMat(2,2);   % Resolution of the encoder (ppr)
  RobotParam.L      = metadataMat(3,2);   % Distance between the wheels - wheelbase (m)
  RobotParam.D      = metadataMat(4,2:3); % Diameter of the wheels (m)

  % Robot Specific Parameters
  if (strcmp(RobotParam.type,'diff'))
    % Add here, if necessary, specific parameters

  elseif (strcmp(RobotParam.type,'tricyc'))
    RobotParam.ThOff = metadataMat(5,2);

  elseif (strcmp(RobotParam.type,'omni3'))  
    RobotParam.J      = [
             -(3^(1/2))/3 ,         (3^(1/2))/3 ,                   0 ; ...
                     -1/3 ,                -1/3 ,                 2/3 ; ...
      -1/(3*RobotParam.L) , -1/(3*RobotParam.L) , -1/(3*RobotParam.L)   ...
    ];
    RobotParam.Jinv = eye(3)/RobotParam.J;

  elseif (strcmp(RobotParam.type,'omni4'))
    RobotParam.J = [
                                           1/4 ,                                     -1/4 ,                                      1/4 ,                                     -1/4 ; ...
                                          -1/4 ,                                     -1/4 ,                                      1/4 ,                                      1/4 ; ...
      -1/(2*(RobotParam.L(1)+RobotParam.L(2))) , -1/(2*(RobotParam.L(1)+RobotParam.L(2))) , -1/(2*(RobotParam.L(1)+RobotParam.L(2))) , -1/(2*(RobotParam.L(1)+RobotParam.L(2)))   ...
    ];
    RobotParam.Jinv = RobotParam.J'/(RobotParam.J*RobotParam.J');
    
  end
end