import { Test, TestingModule } from "@nestjs/testing";
import { PostsController } from "./posts.controller"
import { PostsService } from "./posts.service";
import { post, postInfo, posts, profile, query, updatePostInfo, updatedPost } from "./mocks/mocks";
import { AuthService } from "../auth/auth.service";
import { ProfilesService } from "../profiles/profiles.service";

describe('postsController', () => {
    let controller: PostsController;
    let service: PostsService;

    beforeEach(async () => {
        const mockService = () => ({
            createPost: jest.fn(),
            paginatePosts: jest.fn(),
            findOneById: jest.fn(),
            paginateUserPosts: jest.fn(),
            updatePost: jest.fn(),
            deletePost: jest.fn(),
        })

        const module: TestingModule = await Test.createTestingModule({
            providers: [
                PostsController,
                {
                    provide: PostsService,
                    useValue: mockService(),
                },
                {
                    provide: AuthService,
                    useValue: {}
                },
                {
                    provide: ProfilesService,
                    useValue: {}
                }
            ]
        }).compile();
        controller = module.get<PostsController>(PostsController);
        service = module.get<PostsService>((PostsService));
    });

    describe('createPost', () => {
        it('유저가 입력한 정보로 post 생성', async () => {
            jest.spyOn(service, 'createPost').mockResolvedValue(post);
            const result = await controller.createPost(postInfo, profile);
            expect(result).toEqual(post);
        })
    })

    describe('getPosts', () => {
        it('홈에 보여줄 게시글 요청', async () => {
            jest.spyOn(service, 'paginatePosts').mockResolvedValue(posts);
            const result = await controller.getPosts(query);
            expect(result).toEqual(posts);
        })
    })

    describe('getPostById', () => {
        it('유저가 id의 해당하는 게시글을 요청', async () => {
            jest.spyOn(service, 'findOneById').mockResolvedValue(post);
            const result = await controller.getPostById(post.id);
            expect(result).toEqual(post);
        })
    })

    describe('getUserPosts', () => {
        it('특정 유저의 게시글 요청', async () => {
            jest.spyOn(service, 'paginateUserPosts').mockResolvedValue(posts);
            const result = await controller.getUserPosts(profile.publicId, query);
            expect(result).toEqual(posts);
        })
    })

    describe('getMyPosts', () => {
        it('내 게시글 요청', async () => {
            jest.spyOn(service, 'paginateUserPosts').mockResolvedValue(posts);
            const result = await controller.getMyPosts(profile, query);
            expect(result).toEqual(posts);
        })
    })

    describe('updateMyPost', () => {
        it('내 게시글 수정 후 수정되었는지 확인하기', async () => {
            jest.spyOn(service, 'updatePost').mockResolvedValue(updatedPost);
            const result = await controller.updateMyPost(updatedPost.id, updatePostInfo);
            expect(result).toEqual(updatedPost);
        })
    })
})