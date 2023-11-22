import { ExecutionContext, InternalServerErrorException, createParamDecorator } from "@nestjs/common";


export const AppleToken = createParamDecorator(
    (data, context: ExecutionContext) => {
        const req = context.switchToHttp().getRequest();
        
        const token = req.body.token;

        if(!token) {
            throw new InternalServerErrorException('token이 없습니다.');
        }

        return token;
    }
);