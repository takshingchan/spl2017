function reproduce
% reproduce: Reproduce research.

%	Tak-Shing Chan, 20160830

% Separation
go('separation','rpca','ikala',1,2)
go('separation','rpcai','ikala',1,2)
go('separation','lrr','ikala',1,2)
go('separation','lrri','ikala',1,2)
go('separation','gsr','ikala',1,2)
go('separation','gsri','ikala',1,2)
go('separation','gsri','dsd300',1,1)
go('separation','gsri','dsd100x3',1,1)

% Report
go('report','rpca','ikala',1,2)
go('report','rpcai','ikala',1,2)
go('report','lrr','ikala',1,2)
go('report','lrri','ikala',1,2)
go('report','gsr','ikala',1,2)
go('report','gsri','ikala',1,2)
go('report','gsri','dsd300',1,1)
go('report','gsri','dsd100x3',1,1)
