require "rails_helper"

describe LessonsController do

  describe "POST complete" do
    let!(:course) { Fabricate(:course, published: true, premium_course: false) }
    let!(:lesson) { Fabricate(:lesson, course_id: course.id, published: true) }

    let!(:course_2) { Fabricate(:course, published: true, premium_course: true) }
    let!(:lesson_2) { Fabricate(:lesson, course_id: course_2.id, published: true) }

    let!(:user) { Fabricate(:user) }
    let!(:paid_user) { Fabricate(:user, membership_level: "paid") }

    context "free user" do
      it "Creates a UserAction object" do
        sign_in_free_member(user)
        user.enroll_in(course)
        post :complete, course_id: course.slug, lesson_id: lesson.slug
        expect(UserAction.count).to eq(1)
      end
    end


    context "paid user" do
      it "Creates a UserAction object" do
        sign_in_paid_member(paid_user)
        paid_user.enroll_in(course_2)
        post :complete, course_id: course_2.slug, lesson_id: lesson_2.slug
        expect(UserAction.count).to eq(1)
      end
    end



  end


  describe "GET show" do
    let!(:free_published_course) { Fabricate(:course, published: true, premium_course: false) }
    let!(:lesson_1) { Fabricate(:lesson, course_id: free_published_course.id, published: true) }
    let!(:lesson_2) { Fabricate(:lesson, course_id: free_published_course.id, published: true) }
    let!(:lesson_3) { Fabricate(:lesson, course_id: free_published_course.id) }

    let!(:free_unpublished_course) { Fabricate(:course, premium_course: false) }
    let!(:lesson_4) { Fabricate(:lesson, course_id: free_unpublished_course.id, published: true) }
    let!(:lesson_5) { Fabricate(:lesson, course_id: free_unpublished_course.id, published: true) }
    let!(:lesson_6) { Fabricate(:lesson, course_id: free_unpublished_course.id) }


    let!(:paid_published_course) { Fabricate(:course, published: true, premium_course: true) }
    let!(:lesson_7) { Fabricate(:lesson, course_id: paid_published_course.id, published: true) }
    let!(:lesson_8) { Fabricate(:lesson, course_id: paid_published_course.id, published: true) }
    let!(:lesson_9) { Fabricate(:lesson, course_id: paid_published_course.id) }

    let!(:paid_unpublished_course) { Fabricate(:course, premium_course: true) }
    let!(:lesson_10) { Fabricate(:lesson, course_id: paid_unpublished_course.id, published: true) }
    let!(:lesson_11) { Fabricate(:lesson, course_id: paid_unpublished_course.id, published: true) }
    let!(:lesson_12) { Fabricate(:lesson, course_id: paid_unpublished_course.id) }

    context "user not enrolled in course" do
      it "redirects free user to course page" do
        sign_in_free_member
        get :show, course_id: free_published_course.slug, id: lesson_1.slug
        expect(response).to redirect_to course_path(free_published_course)
      end

      it "redirects paid user to course page" do
        sign_in_paid_member
        get :show, course_id: paid_published_course.slug, id: lesson_7.slug
        expect(response).to redirect_to course_path(paid_published_course)
      end

    end

    context "not logged in" do
      it_behaves_like "requires sign in" do
        let(:action) { get :show, course_id: free_published_course.slug, id: lesson_1.slug}
      end
    end

    context "free user logged in free course-lesson" do
      before do
        free_member = Fabricate(:user)
        sign_in_free_member(free_member)
        free_member.enroll_in(free_published_course)
        get :show, course_id: free_published_course.slug, id: lesson_1.slug
      end

      it "assigns @comment" do
        expect(assigns(:comment)).not_to be_nil
      end
    end 

    context "free user logged in premium course-lesson" do
      it_behaves_like "free user signs in but requires premium member" do
        let(:action) { get :show, course_id: paid_published_course.slug, id: lesson_1.slug}
      end
    end 

    context "paid user logged in course" do
      before do
        paid_member = Fabricate(:user, membership_level: "paid")
        sign_in_paid_member(paid_member)
        paid_member.enroll_in(paid_published_course)
        get :show, course_id: paid_published_course.slug, id: lesson_7.slug
      end

      it "assigns comment" do
        expect(assigns(:comment)).not_to be_nil
      end
    end

    context "admin logged in" do
      before do
        sign_in_admin
      end

      it "allows user to view paid unpublished lesson when not enrolled" do
        get :show, course_id: paid_unpublished_course.slug, id: lesson_12.slug
        expect(assigns(:lesson)).to eq(lesson_12)
      end
      
      it "allows user to view free unpublished lesson when not enrolled" do
        get :show, course_id: free_unpublished_course.slug, id: lesson_6.slug
        expect(assigns(:lesson)).to eq(lesson_6)
      end

    end
  end # GET show



end