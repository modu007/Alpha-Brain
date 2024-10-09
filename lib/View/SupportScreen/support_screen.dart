import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xffE8ECF4),
                            )
                        ),
                        child:SvgPicture.asset("assets/svg/back_arrow.svg"),
                      ),
                    ),
                    const SizedBox(width: 15,),
                    const SimpleText(
                      text: "Support Center",
                      fontSize: 25,
                      fontColor: Color(0xff4EB3CA),
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Section(
                    title: 'Getting Started',
                    content:
                        "If you're new to Z Alpha Brains, make sure to review our Terms of Use and Privacy Policy available on our website www.zalphabrains.com. It provides essential information about your rights and responsibilities while using our platform."),
                const Section(
                    title: 'Services Overview',
                    content:
                        'Explore the diverse services we offer, including discovering, watching, and sharing digital content. Learn about interactive options such as reacting to posts and bookmarking, enhancing your experience on the platform.'),
                const Section(
                    title: 'User Guidelines:',
                    content:
                        'Understand how to use our platform responsibly. Follow our user restrictions and guidelines to ensure a positive and safe environment for all users. Learn about interactive features like reacting to posts and bookmarking.'),
                const Section(
                    title: 'Intellectual Property Rights:',
                    content:
                        'Discover how we protect intellectual property rights and how to report copyright violations. If you believe your copyright has been infringed, contact us at legal@neuralcodeai.in with relevant proof.'),
                const Section(
                    title: 'Account Management:',
                    content:
                        'Learn about account creation, password security, and the consequences of violating our Terms of Use. Understand how to navigate through account suspension and termination.'),
                const Section(
                    title: 'Support and Communication:',
                    content:
                        'For any support-related queries or assistance, please contact us at support legal@neuralcodeai.in . We value your feedback and encourage you to share your thoughts on our services.'),
                const Section(
                    title: 'General Provisions:',
                    content:
                        'Explore important details about notices, assignment, severability, and waiver. Familiarize yourself with our indemnification clause and the limitations of liability outlined in our Terms of Use.'),
                const Section(
                    title: 'Governing Laws and Jurisdiction',
                    content:
                        'Understand the governing laws and jurisdiction applicable to any disputes. Learn about the manner of dispute resolution and the process involved.'),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "For further assistance or to report any issues, please don't hesitate to contact our support team at",
                        style: GoogleFonts.besley(
                          fontSize: 14,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: " legal@neuralcodeai.in ",
                        style: GoogleFonts.besley(
                          fontSize: 14,
                          color: const Color(0xff4EB3CA),
                          height: 1.2,
                        ),
                      ),
                      TextSpan(
                        text:
                            ".Thank you for being a part of the Z Alpha Brains community! Copyright © 2024, All rights reserved.",
                        style: GoogleFonts.besley(
                            fontSize: 14, height: 1.2, color: Colors.black),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final String content;

  const Section({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SimpleText(text: title, fontSize: 18, fontWeight: FontWeight.bold),
        const SizedBox(height: 8.0),
        SimpleText(
          text: content,
          fontSize: 14,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
