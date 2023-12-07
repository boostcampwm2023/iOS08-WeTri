import { UpdateResult } from "typeorm";
import { Profile } from "../../profiles/entities/profiles.entity";
import { CreatePostDto } from "../dto/create-post.dto";
import { PostDto, PostsPaginateResDto } from "../dto/get-posts-response.dto";
import { PaginatePostDto } from "../dto/paginate-post.dto";
import { UpdatePostDto } from "../dto/update-post.dto";

export const postInfo: CreatePostDto = {
    content: 'test content',
    postUrl: 'naver.com',
    recordId: 1,
};

export const updatePostInfo: UpdatePostDto =  {
    content: 'update content',
    postUrl: 'google.com',
}

export const profile = {
    publicId: 'XVZXC-ASFSA123-ASFSF',
    nickname: 'testNickname'
} as Profile

export const query: PaginatePostDto = {
    where__id__less_then: 7,
    order__createdAt: 'DESC',
    take: 5,
}

export const post: PostDto = {
    id: 5,
    publicId: profile.publicId,
    content: postInfo.content,
    like: null,
    createdAt: new Date("2023-12-04T05:14:15.879Z"),
    updatedAt: new Date("2023-12-04T05:14:15.879Z"),
    deletedAt: null,
    postUrl: postInfo.postUrl,
    record: {
        id: postInfo.recordId,
        workoutTime: 6000000,
        distance: 100000,
        calorie: 360,
        avgHeartRate: 60,
        minHeartRate: 120,
        maxHeartRate: 180
    },
    profile: {
        nickname: profile.nickname
    }
};
export const updateResult: UpdateResult = { generatedMaps: [], raw: [], affected: 1 };

export const updatedPost: PostDto = {
    id: 5,
    publicId: profile.publicId,
    content: updatePostInfo.content,
    like: null,
    createdAt: new Date("2023-12-04T05:14:15.879Z"),
    updatedAt: new Date("2023-12-05T05:14:15.879Z"),
    deletedAt: null,
    postUrl: updatePostInfo.postUrl,
    record: {
        id: postInfo.recordId,
        workoutTime: 6000000,
        distance: 100000,
        calorie: 360,
        avgHeartRate: 60,
        minHeartRate: 120,
        maxHeartRate: 180
    },
    profile: {
        nickname: profile.nickname
    }
}

export const posts: PostsPaginateResDto = {
    items: [
        {
            id: 6,
            publicId: profile.publicId,
            content: "안녕하세요 누구 누구 입니다.",
            like: null,
            createdAt: new Date("2023-12-04T05:14:15.879Z"),
            updatedAt: new Date("2023-12-04T05:14:15.879Z"),
            deletedAt: null,
            postUrl: "https://www.naver.com",
            record: {
                id: 2,
                workoutTime: 6000000,
                distance: 100000,
                calorie: 360,
                avgHeartRate: 60,
                minHeartRate: 120,
                maxHeartRate: 180
            },
            profile: {
                nickname: profile.nickname
            }
        },
        {
            id: 5,
            publicId: profile.publicId,
            content: "수정한 내용입니다.",
            like: null,
            createdAt: new Date("2023-12-03T13:47:08.677Z"),
            updatedAt: new Date("2023-12-04T12:44:44.000Z"),
            deletedAt: null,
            postUrl: "google.com",
            record: {
                id: 1,
                workoutTime: 100,
                distance: 100,
                calorie: 100,
                avgHeartRate: 100,
                minHeartRate: 100,
                maxHeartRate: 100
            },
            profile: {
                nickname: profile.nickname,
            }
        }
    ],
    metaData: {
        lastItemId: 5,
        isLastCursor: true,
        count: 2
    }
}