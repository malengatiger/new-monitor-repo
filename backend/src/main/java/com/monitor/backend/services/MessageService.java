package com.monitor.backend.services;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.monitor.backend.data.*;
import com.monitor.backend.utils.Emoji;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class MessageService {
    private static final Gson G = new GsonBuilder().setPrettyPrinting().create();
    private static final Logger LOGGER = LoggerFactory.getLogger(MessageService.class.getSimpleName());

    public String sendMessage(Photo photo) throws FirebaseMessagingException {
        String topic = "photos_" + photo.getOrganizationId();
        Message message = Message.builder()
                .putData("photo", G.toJson(photo))
                .setTopic(topic)
                .build();
        String response = FirebaseMessaging.getInstance().send(message);
        LOGGER.info(Emoji.RED_APPLE + Emoji.RED_APPLE + "Successfully sent photo message to FCM topic: "
                + topic+ Emoji.RED_APPLE);
        return response;
    }
    public String sendMessage(Video video) throws FirebaseMessagingException {
        String topic = "videos_" + video.getOrganizationId();
        Message message = Message.builder()
                .putData("video", G.toJson(video))
                .setTopic(topic)
                .build();
        String response = FirebaseMessaging.getInstance().send(message);
        LOGGER.info(Emoji.RED_APPLE + Emoji.RED_APPLE + "Successfully sent video message to FCM topic: "
                + topic + Emoji.RED_APPLE);
        return response;
    }
    public String sendMessage(Condition condition) throws FirebaseMessagingException {
        String topic = "conditions_" + condition.getOrganizationId();
        Message message = Message.builder()
                .putData("condition", G.toJson(condition))
                .setTopic(topic)
                .build();
        String response = FirebaseMessaging.getInstance().send(message);
        LOGGER.info(Emoji.RED_APPLE + Emoji.RED_APPLE + "Successfully sent condition message to FCM topic: "
                + topic + Emoji.RED_APPLE);
        return response;
    }
    public String sendMessage(OrgMessage orgMessage) throws FirebaseMessagingException {
        String topic = "messages_" + orgMessage.getOrganizationId();
        Message message = Message.builder()
                .putData("message", G.toJson(orgMessage))
                .setTopic(topic)
                .build();
        String response = FirebaseMessaging.getInstance().send(message);
        LOGGER.info(Emoji.RED_APPLE + Emoji.RED_APPLE + "Successfully sent org message to FCM topic: "
                + topic + Emoji.RED_APPLE);
        return response;
    }
    public String sendMessage(Project project) throws FirebaseMessagingException {
        String topic = "projects_" + project.getOrganizationId();
        Message message = Message.builder()
                .putData("project", G.toJson(project))
                .setTopic(topic)
                .build();
        String response = FirebaseMessaging.getInstance().send(message);
        LOGGER.info(Emoji.RED_APPLE + Emoji.RED_APPLE + "Successfully sent project message to FCM topic: "
                + topic + Emoji.RED_APPLE);
        return response;
    }
    public String sendMessage(User user) throws FirebaseMessagingException {
        String topic = "users_" + user.getOrganizationId();
        Message message = Message.builder()
                .putData("user", G.toJson(user))
                .setTopic(topic)
                .build();
        String response = FirebaseMessaging.getInstance().send(message);
        LOGGER.info(Emoji.RED_APPLE + Emoji.RED_APPLE + "Successfully sent user message to FCM topic: "
                + topic + Emoji.RED_APPLE);
        return response;
    }
}
